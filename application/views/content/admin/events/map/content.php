<?php echo render_cell ('admin_frame_cell', 'header');?>

<div id='container'>
  <i></i>
  <i></i>
  <i></i>
  <i></i>
  <div id='map'></div>

  <div id='map_context_menu' class='context_menu'>
    <div class='container'>
      <div class='add_marker'>新增節點</div>
      <div class='add'>新增照片</div>
    </div>
  </div>
  <div id='marker_context_menu' class='context_menu'>
    <div class='container'>
      <div class='del'>刪除節點</div>
    </div>
  </div>
  <div id='polyline_context_menu' class='context_menu'>
    <div class='container'>
      <div class='add'>插入節點</div>
    </div>
  </div>

<?php
  if (isset ($message) && $message) { ?>
    <div class='error'><?php echo $message;?></div>
<?php
  } ?>

</div>

<?php echo render_cell ('admin_frame_cell', 'footer');?>
