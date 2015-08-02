<?php echo render_cell ('admin_frame_cell', 'header');?>

<div id='container'>
<?php
  if (isset ($message) && $message) { ?>
    <div class='error'><?php echo $message;?></div>
<?php
  } ?>
  <form action='<?php echo base_url (array ('admin', 'events', 'create'));?>' method='post' enctype='multipart/form-data'>
    <table class='table-form'>
      <tbody>
        <tr>
          <th>名稱</th>
          <td>
            <input type='text' id='name' name='name' value='<?php echo $name;?>' placeholder='請輸入名稱..' maxlength='100' pattern='.{1,200}' required title='輸入 1~200 個字元!' />
          </td>
        </tr>
        <tr>
          <th>敘述</th>
          <td>
            <input type='text' id='description' name='description' value='<?php echo $description;?>' placeholder='請輸入敘述..' />
          </td>
        </tr>
        <tr>
          <th>開啟</th>
          <td>
            <select id='is_visibled' name='is_visibled' >
              <option value='0' <?php echo $is_visibled && $is_visibled == 0 ? ' selected' : '';?>>關閉</option>
              <option value='1' <?php echo $is_visibled && $is_visibled == 1 ? ' selected' : '';?>>開啟</option>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan='2'>
            <a href='<?php echo base_url ('admin', 'events');?>'>回列表</a>
            <button type='reset' class='button'>重填</button>
            <button type='submit' class='button'>確定</button>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>

<?php echo render_cell ('admin_frame_cell', 'footer');?>
