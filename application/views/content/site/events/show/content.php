<?php echo render_cell ('site_frame_cell', 'header');?>
  
<div id='container'>
  <i></i>
  <i></i>
  <i></i>
  <i></i>
  <div id='map'></div>
  <div id='length'><?php echo round ($event->length / 1000, 2);?></div>
</div>

<?php
  foreach ($polylines as $polyline) {?>
    <input type='hidden' name='polylines' data-lat='<?php echo $polyline->latitude;?>' data-lng='<?php echo $polyline->longitude;?>' data-speed='<?php echo $polyline->speed;?>' value='<?php echo $polyline->id;?>' /> 
<?php
  }
?>
<?php echo render_cell ('site_frame_cell', 'footer');?>
