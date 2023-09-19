class Repo {
  final String? htmlUrl;
  final int watchersCount;
  final String? language;
  final String? description;
  final String? name;
  final String? owner;
  final String? lastCommiter;
  final String? commitMsg;

  Repo(
      {this.htmlUrl = '',
      this.watchersCount = 0,
      this.language = '',
      this.description = '',
      this.name = '',
      this.owner = '',
      this.lastCommiter='',
      this.commitMsg=''});

  static List<Repo> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList
        .map((r) => Repo(htmlUrl:r['html_url'], watchersCount:r['watchers_count'], language: r['language'],
        description: r['description'], name: r['name'], owner: r['owner']['login']))
        .toList();
  }
}