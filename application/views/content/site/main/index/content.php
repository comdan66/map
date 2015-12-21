
<div id='container'>
  <div id='polylines'>
    <?php
    foreach ($polylines as $polyline) { ?>
      <a class='polyline' href='<?php echo base_url ('polylines', $polyline->id);?>'>
        <img src='<?php echo $polyline->cover->url ('640x640c');?>' />
        <div><?php echo $polyline->name;?></div>
        <img src="<?php echo $polyline->user->avatar->url ('40x40c');?>" />
      </a>
    <?php
    } ?>
  </div>
  <?php echo render_cell ('frame_cell', 'pagination', $pagination);?>
</div>
