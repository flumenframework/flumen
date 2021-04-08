import 'package:flumen/src/db/postgresql/builders/column.dart';
import 'package:flumen/src/db/postgresql/builders/table.dart';
import 'package:flumen/src/db/query/query.dart';

class ColumnSortBuilder extends ColumnBuilder {
  ColumnSortBuilder(TableBuilder table, String key, QuerySortOrder order)
      : order = order == QuerySortOrder.ascending ? "ASC" : "DESC",
        super(table, table.entity.properties[key]);

  final String order;

  String get sqlOrderBy => "${sqlColumnName(withTableNamespace: true)} $order";
}
