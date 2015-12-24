<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	http://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There area two reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router what URI segments to use if those provided
| in the URL cannot be matched to a valid route.
|
*/
// $route['404_override'] = '';

// $route['default_controller'] = "main";
Route::root ('main');

Route::get ('/(:num)', 'main@index($1)');
Route::get ('polylines/(:num)', 'polylines@content($1)');

// iOS API
  $ios_api_uri = 'api/v2/'; $ios_api_path = 'ios_api_v2/';
  Route::get ($ios_api_uri . 'users/(:id)/polylines/newest', $ios_api_path . 'user_polylines@newest($0)');
  Route::post ($ios_api_uri . 'users/(:id)/polylines/', $ios_api_path . 'user_polylines@create($0)');
  Route::post ($ios_api_uri . 'polylines/(:id)/paths', $ios_api_path . 'polyline_paths@create($0)');
  Route::get ($ios_api_uri . 'polylines/(:id)/paths', $ios_api_path . 'polyline_paths@index($0)');
