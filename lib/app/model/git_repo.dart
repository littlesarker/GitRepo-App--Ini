class GithubRepoModel {
  final int id;
  final String nodeId;
  final String name;
  final String fullName;
  final bool private;
  final String htmlUrl;
  final String? description;
  final bool fork;
  final String url;
  final String createdAt;
  final String updatedAt;
  final String pushedAt;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String? license;
  final String defaultBranch;
  final String visibility;
  final int size;

  GithubRepoModel({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.fullName,
    required this.private,
    required this.htmlUrl,
    this.description,
    required this.fork,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.pushedAt,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    this.license,
    required this.defaultBranch,
    required this.visibility,
    required this.size,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      id: json['id'] ?? 0,
      nodeId: json['node_id'] ?? '',
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      private: json['private'] ?? false,
      htmlUrl: json['html_url'] ?? '',
      description: json['description'],
      fork: json['fork'] ?? false,
      url: json['url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pushedAt: json['pushed_at'] ?? '',
      language: json['language'],
      stargazersCount: json['stargazers_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
      license: json['license']?['name'],
      defaultBranch: json['default_branch'] ?? 'main',
      visibility: json['visibility'] ?? 'public',
      size: json['size'] ?? 0,
    );
  }
}