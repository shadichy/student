final class RoutingSearchFilter {}

final class SubjectSearchFilter {}

final class CourseSearchFilter {}

final class StampSearchFilter {}

final class ArticleSearchFilter {}

final class NotifSearchFilter {}

abstract final class SearchFilter {
  static const route = RoutingSearchFilter.new;
  static const subject = SubjectSearchFilter.new;
  static const course = CourseSearchFilter.new;
  static const stamp = StampSearchFilter.new;
  static const article = ArticleSearchFilter.new;
  static const notif = NotifSearchFilter.new;
}
