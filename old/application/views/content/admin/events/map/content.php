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
      <div class='add_pic'>新增照片</div>
      <div class='save'>儲存路線</div>
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
  <form id='fm' action='<?php echo base_url (array ('admin', 'events', 'map_create', $event->id));?>' method='post' enctype='multipart/form-data'>
    <?php
    if (!$polylines)
      $polylines = $event->polylines;

    foreach ($polylines as $polyline) { ?>
      <input type='hidden' name='polylines' data-lat='<?php echo $polyline->latitude;?>' data-lng='<?php echo $polyline->longitude;?>' value='<?php echo $polyline->id;?>' /> 
<?php
    } ?>
    <button type='submit'>儲存</button>
  </form>
<?php
  if (isset ($message) && $message) { ?>
    <div class='error'><?php echo $message;?></div>
<?php
  } ?>

</div>

<?php echo render_cell ('admin_frame_cell', 'footer');?>
