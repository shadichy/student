final class RoutingSearchFilter {}

final class SubjectSearchFilter {}

final class CourseSearchFilter {}

final class StampSearchFilter {}

final class ArticleSearchFilter {}

final class NotifSearchFilter {}

abstract final class SearchFilter {
  static RoutingSearchFilter route({any}) => RoutingSearchFilter();
  static SubjectSearchFilter subject({any}) => SubjectSearchFilter();
  static CourseSearchFilter course({any}) => CourseSearchFilter();
  static StampSearchFilter stamp({any}) => StampSearchFilter();
  static ArticleSearchFilter article({any}) => ArticleSearchFilter();
  static NotifSearchFilter notif({any}) => NotifSearchFilter();
}
