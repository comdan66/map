<?php echo render_cell ('site_frame_cell', 'header');?>
<div id='container'>
  
<div id='container'>
  <i></i>
  <i></i>
  <i></i>
  <i></i>
  <div id='map'></div>
</div>

<?php
  foreach ($event->polylines as $polyline) {?>
    <input type='hidden' name='polylines' data-lat='<?php echo $polyline->latitude;?>' data-lng='<?php echo $polyline->longitude;?>' value='<?php echo $polyline->id;?>' /> 
<?php
  }
?>
<?php echo render_cell ('site_frame_cell', 'footer');?>
