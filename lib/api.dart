import 'package:flutter_app/repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class Api {
  static final HttpClient _httpClient = HttpClient();
  static const String _url = "api.github.com";

  static Future<List<Repo>?> getRepositories() async {
    final uri = Uri.https(_url, 'users/freeCodeCamp/repos');

    final jsonResponse = await _getJson(uri);

    if (jsonResponse == null) {
      return null;
    }

    print('Obtained the data');
    return jsonResponse;
  }



  static Future<List<Repo>?> _getJson(Uri uri) async {
    try {
      final token = dotenv.env['SECRET_TOKEN'];
      final headers = {
        HttpHeaders.authorizationHeader: 'token $token'
      };

      final httpResponse = await http.get(uri , headers: headers);
      
      if (httpResponse.statusCode != HttpStatus.ok) {
        return null;
      }

      final decodedData = json.decode(httpResponse.body);

      final resultList = decodedData.map<Repo>((r) => Repo(htmlUrl:r['html_url'], watchersCount:r['watchers_count'], language: r['language'],
              description: r['description'], name: r['name'], owner: r['owner']['login'] )).toList();


      return Future<List<Repo>?>.value(resultList);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  static Future<Repo?> fetchUpdatedRepo(Repo r) async {

    if(r.name == null)return r;
    final uri = Uri.https(_url, 'repos/freeCodeCamp/${r.name}/commits');

    try {
      final token = dotenv.env['SECRET_TOKEN'];
      final headers = {
        HttpHeaders.authorizationHeader: 'token $token'
      };

      final httpResponse = await http.get(uri , headers: headers);

      if (httpResponse.statusCode != HttpStatus.ok) {
        print('server Internal error');
        return r;
      }

      final decodedData = json.decode(httpResponse.body);
      final lastCommit = decodedData.first;

      Repo upDatedRepo = Repo(htmlUrl: r.htmlUrl,
        watchersCount: r.watchersCount,
        language: r.language,
        description: r.description,
        name: r.name,
        owner: r.owner,
        lastCommiter: lastCommit['commit']['committer']['name'],
        commitMsg: lastCommit['commit']['message']
      );

      return upDatedRepo;

    } on Exception catch (e) {
      print('exception at fetching latest commit for $r.name repository : $e');
      return null;
    }


  }

}