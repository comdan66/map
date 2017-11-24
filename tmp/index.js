/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2016 OA Wu Design
 */

$(function () {
  $('.glyphicon-eye-open.show').click (function () {
    $.fancybox ({
        href: '/admin/products/show/' + $(this).data ('id') + '?t=' + new Date ().getTime ()+ '&p='+$(this).data ('p'),
        type: 'iframe',
        padding: 0,
        margin: '70 30 30 30',
        width: '320',
        maxWidth: '1200'
    });
  });
  $('.glyphicon-eye-open.time').click (function () {
    $.fancybox ({
        href: '/admin/products/time/' + $(this).data ('id') + '?t=' + new Date ().getTime ()+ '&p='+$(this).data ('p'),
        type: 'iframe',
        padding: 0,
    });
  });
});