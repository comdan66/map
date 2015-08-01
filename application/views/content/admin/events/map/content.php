<?php echo render_cell ('admin_frame_cell', 'header');?>

<div id='container'>
  <i></i>
  <i></i>
  <i></i>
  <i></i>
  <div id='map'></div>
  
<?php
  if (isset ($message) && $message) { ?>
    <div class='error'><?php echo $message;?></div>
<?php
  } ?>

</div>

<?php echo render_cell ('admin_frame_cell', 'footer');?>
