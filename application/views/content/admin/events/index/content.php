<?php echo render_cell ('admin_frame_cell', 'header'); ?>

<div id='container' class='<?php echo !$frame_sides ? 'no_sides': '';?>'>
  <?php
  if (isset ($message) && $message) { ?>
    <div class='info'><?php echo $message;?></div>
<?php
  } ?>
  <form action='<?php echo base_url ('admin', 'events');?>' method='get'<?php echo $has_search ? ' class="show"' : '';?>>
    <div class='l'>
      <input type='text' name='id' value='<?php echo isset ($columns['id']) ? $columns['id'] : '';?>' placeholder='請輸入ID..' />
      <input type='text' name='name' value='<?php echo isset ($columns['name']) ? $columns['name'] : '';?>' placeholder='請輸入名稱..' />
      <input type='text' name='description' value='<?php echo isset ($columns['description']) ? $columns['description'] : '';?>' placeholder='請輸入敘述..' />
    </div>
    <button type='submit' class='submit'>尋找</button>
      <a class='new' href='<?php echo base_url ('admin', 'events', 'add');?>'>新增</a>
  </form>
  <button type='button' onClick="if (!$(this).prev ().is (':visible')) $(this).attr ('class', 'search_feature icon-circle-up').prev ().addClass ('show'); else $(this).attr ('class', 'search_feature icon-circle-down').prev ().removeClass ('show');" class='search_feature icon-circle-<?php echo $has_search ? 'up' : 'down';?>'></button>

  <table class='table-list-rwd'>
    <tbody>
<?php if ($events) {
        foreach ($events as $event) { ?>
          <tr>
            <td data-title='ID' width='100'><?php echo $event->id;?></td>
            <td data-title='名稱' width='200'><?php echo $event->name;?></td>
            <td data-title='敘述'><?php echo $event->description;?></td>
            <td data-title='編輯' width='120' class='middle'>
              <a href='<?php echo base_url ('admin', 'events', 'edit', $event->id);?>' class='icon-pencil2'></a>
              /
              <a href='<?php echo base_url ('admin', 'events', 'destroy', $event->id);?>' class='icon-bin'></a>
            </td>
          </tr>
  <?php }
      } else { ?>
        <tr><td colspan>目前沒有任何資料。</td></tr>
<?php }?>
    </tbody>
  </table>
  <?php echo render_cell ('admin_frame_cell', 'pagination', $pagination);?>
</div>

<?php echo render_cell ('admin_frame_cell', 'footer');?>
