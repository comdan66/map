<?php echo render_cell ('site_frame_cell', 'header');?>
<div id='container'>
  <div class='units'>

<?php
    foreach ($events as $event) { ?>
      <a href='<?php echo base_url ('event', $event->id);?>' class='unit'>
          <img src='<?php echo $event->cover->url ('400x400c');?>' alt='<?php echo $event->name;?>'/>
          <div class='title'><?php echo $event->name;?></div>
          <div class='bottom'>
            <div class='l'>總長度：<?php echo round ($event->length / 1000, 2);?> Km</div>
            <div class='r'>歷經：<?php echo $event->run_time_str (); ?></div>
          </div>
        </a>
  <?php
    } ?>

  </div>
</div>
<?php echo render_cell ('site_frame_cell', 'footer');?>
