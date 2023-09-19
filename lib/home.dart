import 'package:flutter/material.dart';
import 'package:flutter_app/api.dart';
import 'package:flutter_app/repo.dart';
import 'package:flutter_app/item.dart';

class Home extends StatefulWidget {
  Home();

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repo> _repos = [];
  bool _isFetching = false;
  String _error="";

  @override
  void initState() {
    super.initState();
    loadTrendingRepos();
  }

  void loadTrendingRepos() async {

    final repos = await Api.getRepositories();
    setState(() {
      _isFetching = false;
      if (repos != null) {
        _repos = repos;
      } else {
        _error = 'Error fetching repos';
      }
    });

    loadLatestCommits();

  }

  void loadLatestCommits() async {

    List<Repo> updatedRepos = [];
    for(int i=0;i<_repos.length; i++)
    {
      final Repo? r = await Api.fetchUpdatedRepo(_repos[i]);
      if(r != null)
      {
        setState(() {
          _repos[i] = r;
        });
      }

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(top: 4.0),
            child: Column(
              children: <Widget>[
                Text('Github Repos',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: Colors.white))
              ],
            )),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {

    if (_isFetching) {
      return Container(
          alignment: Alignment.center, child: Icon(Icons.timelapse));
    } else if (_error != "") {
      return Container(
          alignment: Alignment.center,
          child: Text(
            _error,
            style: Theme.of(context).textTheme.titleMedium,
          ));
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _repos.length,
          itemBuilder: (BuildContext context, int index) {
            return GithubItem(_repos[index]);
          });
    }
  }
}