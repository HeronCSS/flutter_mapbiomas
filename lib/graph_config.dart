import 'package:graphql/client.dart';
import 'package:latlong2/latlong.dart';

class GraphQLService {

  GraphQLClient client = GraphQLClient(
      link: HttpLink('https://plataforma.alerta.mapbiomas.org/api/v2/graphql', defaultHeaders: {
        'Authorization':'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEwMzQzLCJuYW1lIjoiSGVyb24gQ0FSIExvcyBEYSBTaWx2YSBTYW50b3MiLCJlbWFpbCI6Imhlcm9uMTFjYXJsb3NAZ21haWwuY29tIiwicHJvZmlsZSI6InJlZ3VsYXIiLCJhdmF0YXIiOm51bGwsImxhc3RfbG9naW5fYXQiOiIyMDI0LTEwLTIzIDA3OjMxOjAyIC0wMzAwIiwibGFzdF91cGRhdGVkX3Bhc3N3b3JkX2F0IjoiMjAyNC0wOS0yMCAxNzoxMzowMiAtMDMwMCIsIm5vdGlmeV91c2VyX25ld190ZXJtX29mX3VzZV92ZXJzaW9uIjpmYWxzZSwidW5zZWVuX2FsZXJ0cyI6MCwiaW5zdGl0dXRpb24iOnsiaWQiOm51bGwsIm5hbWUiOm51bGwsImFiYnJldmlhdGlvbiI6bnVsbH0sImV4cCI6MTcyOTY5NzY3MX0.P5oBcmu1xp5G8mTWmwgf_vIe6NGLys4maV_K4q8pBYY'
      }),
      cache: GraphQLCache(
        partialDataPolicy: PartialDataCachePolicy.reject,
      ));

  getAlertas() async {
    QueryResult result = await client.query(QueryOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql("""query alerts{
  alerts(startDate: "2024-01-01"){
    __typename collection {
      __typename coordenates {
        __typename latitude
        __typename longitude
      }
    }
  }
}""")));
    List l = result.data?["alerts"]["collection"];
    List<LatLng> coordenates = List.empty(growable: true);
    for(int i=0;i<l.length;i++){
      coordenates.add(LatLng(l[i]["coordenates"]["latitude"], l[i]["coordenates"]["longitude"]));
    }
    return coordenates;
  }
}