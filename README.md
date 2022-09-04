# NetflixClone

15 days  

## Instructions 
create api.dart in lib/core/ with this code

```
import 'package:dio/dio.dart';  
  
const kBaseUrl = 'https://api.themoviedb.org/3';  
const kApiKey = '';  
const kServerError = 'Failed to connect';  

const kHeaders = {'Authorization': 'Beared $kApiKey'};  
  
final kDioOptions = BaseOptions(  
  baseUrl: kBaseUrl,  
  connectTimeout: 5000,  
  receiveTimeout: 3000,  
  contentType: 'application/json;charset=utf-8',  
  headers: headers,  
);  
```