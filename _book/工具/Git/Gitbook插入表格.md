# Gitbook插入表格

Markdown表格设计

Markdown本身不提供单元格合并语法，好在Markdown是兼容HTML的，通过HTML的方式实现单元格合并。

[在线生成表格](http://pressbin.com/tools/excel_to_html_table/index.html)

## 行合并 示例1：
```
<table>
<tr>                                       #<tr></tr>的个数为：行数
    <td rowspan="7"> 合并多行成一列：<br/>  #<td></td>的个数为：列数
        使用rowspan="n" <br/>
        跨 n 行合并<br/>
        </td>
    <td>文件标识：</td>
    <td>内容</td>
</tr>
<tr>
    <td>第一行：</td>
    <td>该写什么呢？</td>
</tr>
<tr>
    <td>第二行：</td>
    <td>随便写吧！</td>
</tr>
<tr>
    <td>第三行：</td>
    <td>OK了！</td>
</tr>
</table>
```
<table>
<tr>                                       
    <td rowspan="7"> 合并多行成一列：<br/>
        使用rowspan="n" <br/>
        跨 n 行合并<br/>
        </td>
    <td>文件标识：</td>
    <td>内容</td>
</tr>
<tr>
    <td>第一行：</td>
    <td>该写什么呢？</td>
</tr>
<tr>
    <td>第二行：</td>
    <td>随便写吧！</td>
</tr>
<tr>
    <td>第三行：</td>
    <td>OK了！</td>
</tr>
</table>
## 列合并 示例2：
```
<table>
    <tr>
        <td bgcolor=#FF69B4>第一列</td> 
        <td>第二列</td>
        <td>第三列</td> 
   </tr>
    <tr>
        <td colspan="2"bgcolor=#7B68EE>合并第1，2列</td>
        <td>第2行，第3列</td    
    </tr>
    <tr>
        <td colspan="2" bgcolor=#ADFF2F>合并第1，2列</td>
        <td>第3行，第3列</td    
    </tr>
</table>
```
<table>
    <tr>
        <td bgcolor=#FF69B4>第一列</td> 
        <td>第二列</td>
        <td>第三列</td> 
   </tr>
    <tr>
        <td colspan="2"bgcolor=#7B68EE>合并第1，2列</td>
        <td>第2行，第3列</td    
    </tr>
    <tr>
        <td colspan="2" bgcolor=#ADFF2F>合并第1，2列</td>
        <td>第3行，第3列</td    
    </tr>
</table>

- 使用跨行或者跨列时，使用th标签
- 跨行： rowspan的的参数就是要跨的行数
- 跨列： colspan的参数就是要跨的列数

## 颜色库

<table>
  <tbody><tr>
    <td width="30" bgcolor="#ffffff" height="30"></td>
    <td>#FFFFFF</td>
    <td width="30" bgcolor="#fffff0" height="30"></td>
    <td>#FFFFF0</td>
    <td width="30" bgcolor="#ffffe0" height="30"></td>
    <td>#FFFFE0</td>
    <td width="30" bgcolor="#ffff00" height="30"></td>
    <td>#FFFF00</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#fffafa" height="30"></td>
    <td>#FFFAFA</td>
    <td width="30" bgcolor="#fffaf0" height="30"></td>
    <td>#FFFAF0</td>
    <td width="30" bgcolor="#fffacd" height="30"></td>
    <td>#FFFACD</td>
    <td width="30" bgcolor="#fff8dc" height="30"></td>
    <td>#FFF8DC</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#fff68f" height="30"></td>
    <td>#FFF68F</td>
    <td width="30" bgcolor="#fff5ee" height="30"></td>
    <td>#FFF5EE</td>
    <td width="30" bgcolor="#fff0f5" height="30"></td>
    <td>#FFF0F5</td>
    <td width="30" bgcolor="#ffefdb" height="30"></td>
    <td>#FFEFDB</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffefd5" height="30"></td>
    <td>#FFEFD5</td>
    <td width="30" bgcolor="#ffec8b" height="30"></td>
    <td>#FFEC8B</td>
    <td width="30" bgcolor="#ffebcd" height="30"></td>
    <td>#FFEBCD</td>
    <td width="30" bgcolor="#ffe7ba" height="30"></td>
    <td>#FFE7BA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffe4e1" height="30"></td>
    <td>#FFE4E1</td>
    <td width="30" bgcolor="#ffe4c4" height="30"></td>
    <td>#FFE4C4</td>
    <td width="30" bgcolor="#ffe4b5" height="30"></td>
    <td>#FFE4B5</td>
    <td width="30" bgcolor="#ffe1ff" height="30"></td>
    <td>#FFE1FF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffdead" height="30"></td>
    <td>#FFDEAD</td>
    <td width="30" bgcolor="#ffdab9" height="30"></td>
    <td>#FFDAB9</td>
    <td width="30" bgcolor="#ffd700" height="30"></td>
    <td>#FFD700</td>
    <td width="30" bgcolor="#ffd39b" height="30"></td>
    <td>#FFD39B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffc1c1" height="30"></td>
    <td>#FFC1C1</td>
    <td width="30" bgcolor="#ffc125" height="30"></td>
    <td>#FFC125</td>
    <td width="30" bgcolor="#ffc0cb" height="30"></td>
    <td>#FFC0CB</td>
    <td width="30" bgcolor="#ffbbff" height="30"></td>
    <td>#FFBBFF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffb90f" height="30"></td>
    <td>#FFB90F</td>
    <td width="30" bgcolor="#ffb6c1" height="30"></td>
    <td>#FFB6C1</td>
    <td width="30" bgcolor="#ffb5c5" height="30"></td>
    <td>#FFB5C5</td>
    <td width="30" bgcolor="#ffaeb9" height="30"></td>
    <td>#FFAEB9</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ffa54f" height="30"></td>
    <td>#FFA54F</td>
    <td width="30" bgcolor="#ffa500" height="30"></td>
    <td>#FFA500</td>
    <td width="30" bgcolor="#ffa07a" height="30"></td>
    <td>#FFA07A</td>
    <td width="30" bgcolor="#ff8c69" height="30"></td>
    <td>#FF8C69</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ff8c00" height="30"></td>
    <td>#FF8C00</td>
    <td width="30" bgcolor="#ff83fa" height="30"></td>
    <td>#FF83FA</td>
    <td width="30" bgcolor="#ff82ab" height="30"></td>
    <td>#FF82AB</td>
    <td width="30" bgcolor="#ff8247" height="30"></td>
    <td>#FF8247</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ff7f50" height="30"></td>
    <td>#FF7F50</td>
    <td width="30" bgcolor="#ff7f24" height="30"></td>
    <td>#FF7F24</td>
    <td width="30" bgcolor="#ff7f00" height="30"></td>
    <td>#FF7F00</td>
    <td width="30" bgcolor="#ff7256" height="30"></td>
    <td>#FF7256</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ff6eb4" height="30"></td>
    <td>#FF6EB4</td>
    <td width="30" bgcolor="#ff6a6a" height="30"></td>
    <td>#FF6A6A</td>
    <td width="30" bgcolor="#ff69b4" height="30"></td>
    <td>#FF69B4</td>
    <td width="30" bgcolor="#ff6347" height="30"></td>
    <td>#FF6347</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ff4500" height="30"></td>
    <td>#FF4500</td>
    <td width="30" bgcolor="#ff4040" height="30"></td>
    <td>#FF4040</td>
    <td width="30" bgcolor="#ff3e96" height="30"></td>
    <td>#FF3E96</td>
    <td width="30" bgcolor="#ff34b3" height="30"></td>
    <td>#FF34B3</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ff3030" height="30"></td>
    <td>#FF3030</td>
    <td width="30" bgcolor="#ff1493" height="30"></td>
    <td>#FF1493</td>
    <td width="30" bgcolor="#ff00ff" height="30"></td>
    <td>#FF00FF</td>
    <td width="30" bgcolor="#ff0000" height="30"></td>
    <td>#FF0000</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#fdf5e6" height="30"></td>
    <td>#FDF5E6</td>
    <td width="30" bgcolor="#fcfcfc" height="30"></td>
    <td>#FCFCFC</td>
    <td width="30" bgcolor="#fafafa" height="30"></td>
    <td>#FAFAFA</td>
    <td width="30" bgcolor="#fafad2" height="30"></td>
    <td>#FAFAD2</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#faf0e6" height="30"></td>
    <td>#FAF0E6</td>
    <td width="30" bgcolor="#faebd7" height="30"></td>
    <td>#FAEBD7</td>
    <td width="30" bgcolor="#fa8072" height="30"></td>
    <td>#FA8072</td>
    <td width="30" bgcolor="#f8f8ff" height="30"></td>
    <td>#F8F8FF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#f7f7f7" height="30"></td>
    <td>#F7F7F7</td>
    <td width="30" bgcolor="#f5fffa" height="30"></td>
    <td>#F5FFFA</td>
    <td width="30" bgcolor="#f5f5f5" height="30"></td>
    <td>#F5F5F5</td>
    <td width="30" bgcolor="#f5f5dc" height="30"></td>
    <td>#F5F5DC</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#f5deb3" height="30"></td>
    <td>#F5DEB3</td>
    <td width="30" bgcolor="#f4f4f4" height="30"></td>
    <td>#F4F4F4</td>
    <td width="30" bgcolor="#f4a460" height="30"></td>
    <td>#F4A460</td>
    <td width="30" bgcolor="#f2f2f2" height="30"></td>
    <td>#F2F2F2</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#f0ffff" height="30"></td>
    <td>#F0FFFF</td>
    <td width="30" bgcolor="#f0fff0" height="30"></td>
    <td>#F0FFF0</td>
    <td width="30" bgcolor="#f0f8ff" height="30"></td>
    <td>#F0F8FF</td>
    <td width="30" bgcolor="#f0f0f0" height="30"></td>
    <td>#F0F0F0</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#f0e68c" height="30"></td>
    <td>#F0E68C</td>
    <td width="30" bgcolor="#f08080" height="30"></td>
    <td>#F08080</td>
    <td width="30" bgcolor="#eeeee0" height="30"></td>
    <td>#EEEEE0</td>
    <td width="30" bgcolor="#eeeed1" height="30"></td>
    <td>#EEEED1</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eeee00" height="30"></td>
    <td>#EEEE00</td>
    <td width="30" bgcolor="#eee9e9" height="30"></td>
    <td>#EEE9E9</td>
    <td width="30" bgcolor="#eee9bf" height="30"></td>
    <td>#EEE9BF</td>
    <td width="30" bgcolor="#eee8cd" height="30"></td>
    <td>#EEE8CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eee8aa" height="30"></td>
    <td>#EEE8AA</td>
    <td width="30" bgcolor="#eee685" height="30"></td>
    <td>#EEE685</td>
    <td width="30" bgcolor="#eee5de" height="30"></td>
    <td>#EEE5DE</td>
    <td width="30" bgcolor="#eee0e5" height="30"></td>
    <td>#EEE0E5</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eedfcc" height="30"></td>
    <td>#EEDFCC</td>
    <td width="30" bgcolor="#eedc82" height="30"></td>
    <td>#EEDC82</td>
    <td width="30" bgcolor="#eed8ae" height="30"></td>
    <td>#EED8AE</td>
    <td width="30" bgcolor="#eed5d2" height="30"></td>
    <td>#EED5D2</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eed5b7" height="30"></td>
    <td>#EED5B7</td>
    <td width="30" bgcolor="#eed2ee" height="30"></td>
    <td>#EED2EE</td>
    <td width="30" bgcolor="#eecfa1" height="30"></td>
    <td>#EECFA1</td>
    <td width="30" bgcolor="#eecbad" height="30"></td>
    <td>#EECBAD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eec900" height="30"></td>
    <td>#EEC900</td>
    <td width="30" bgcolor="#eec591" height="30"></td>
    <td>#EEC591</td>
    <td width="30" bgcolor="#eeb4b4" height="30"></td>
    <td>#EEB4B4</td>
    <td width="30" bgcolor="#eeb422" height="30"></td>
    <td>#EEB422</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eeaeee" height="30"></td>
    <td>#EEAEEE</td>
    <td width="30" bgcolor="#eead0e" height="30"></td>
    <td>#EEAD0E</td>
    <td width="30" bgcolor="#eea9b8" height="30"></td>
    <td>#EEA9B8</td>
    <td width="30" bgcolor="#eea2ad" height="30"></td>
    <td>#EEA2AD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee9a49" height="30"></td>
    <td>#EE9A49</td>
    <td width="30" bgcolor="#ee9a00" height="30"></td>
    <td>#EE9A00</td>
    <td width="30" bgcolor="#ee9572" height="30"></td>
    <td>#EE9572</td>
    <td width="30" bgcolor="#ee82ee" height="30"></td>
    <td>#EE82EE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee8262" height="30"></td>
    <td>#EE8262</td>
    <td width="30" bgcolor="#ee7ae9" height="30"></td>
    <td>#EE7AE9</td>
    <td width="30" bgcolor="#ee799f" height="30"></td>
    <td>#EE799F</td>
    <td width="30" bgcolor="#ee7942" height="30"></td>
    <td>#EE7942</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee7621" height="30"></td>
    <td>#EE7621</td>
    <td width="30" bgcolor="#ee7600" height="30"></td>
    <td>#EE7600</td>
    <td width="30" bgcolor="#ee6aa7" height="30"></td>
    <td>#EE6AA7</td>
    <td width="30" bgcolor="#ee6a50" height="30"></td>
    <td>#EE6A50</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee6363" height="30"></td>
    <td>#EE6363</td>
    <td width="30" bgcolor="#ee5c42" height="30"></td>
    <td>#EE5C42</td>
    <td width="30" bgcolor="#ee4000" height="30"></td>
    <td>#EE4000</td>
    <td width="30" bgcolor="#ee3b3b" height="30"></td>
    <td>#EE3B3B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee3a8c" height="30"></td>
    <td>#EE3A8C</td>
    <td width="30" bgcolor="#ee30a7" height="30"></td>
    <td>#EE30A7</td>
    <td width="30" bgcolor="#ee2c2c" height="30"></td>
    <td>#EE2C2C</td>
    <td width="30" bgcolor="#ee1289" height="30"></td>
    <td>#EE1289</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#ee00ee" height="30"></td>
    <td>#EE00EE</td>
    <td width="30" bgcolor="#ee0000" height="30"></td>
    <td>#EE0000</td>
    <td width="30" bgcolor="#ededed" height="30"></td>
    <td>#EDEDED</td>
    <td width="30" bgcolor="#ebebeb" height="30"></td>
    <td>#EBEBEB</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#eaeaea" height="30"></td>
    <td>#EAEAEA</td>
    <td width="30" bgcolor="#e9967a" height="30"></td>
    <td>#E9967A</td>
    <td width="30" bgcolor="#e8e8e8" height="30"></td>
    <td>#E8E8E8</td>
    <td width="30" bgcolor="#e6e6fa" height="30"></td>
    <td>#E6E6FA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#e5e5e5" height="30"></td>
    <td>#E5E5E5</td>
    <td width="30" bgcolor="#e3e3e3" height="30"></td>
    <td>#E3E3E3</td>
    <td width="30" bgcolor="#e0ffff" height="30"></td>
    <td>#E0FFFF</td>
    <td width="30" bgcolor="#e0eeee" height="30"></td>
    <td>#E0EEEE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#e0eee0" height="30"></td>
    <td>#E0EEE0</td>
    <td width="30" bgcolor="#e0e0e0" height="30"></td>
    <td>#E0E0E0</td>
    <td width="30" bgcolor="#e066ff" height="30"></td>
    <td>#E066FF</td>
    <td width="30" bgcolor="#dedede" height="30"></td>
    <td>#DEDEDE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#deb887" height="30"></td>
    <td>#DEB887</td>
    <td width="30" bgcolor="#dda0dd" height="30"></td>
    <td>#DDA0DD</td>
    <td width="30" bgcolor="#dcdcdc" height="30"></td>
    <td>#DCDCDC</td>
    <td width="30" bgcolor="#dc143c" height="30"></td>
    <td>#DC143C</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#dbdbdb" height="30"></td>
    <td>#DBDBDB</td>
    <td width="30" bgcolor="#db7093" height="30"></td>
    <td>#DB7093</td>
    <td width="30" bgcolor="#daa520" height="30"></td>
    <td>#DAA520</td>
    <td width="30" bgcolor="#da70d6" height="30"></td>
    <td>#DA70D6</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#d9d9d9" height="30"></td>
    <td>#D9D9D9</td>
    <td width="30" bgcolor="#d8bfd8" height="30"></td>
    <td>#D8BFD8</td>
    <td width="30" bgcolor="#d6d6d6" height="30"></td>
    <td>#D6D6D6</td>
    <td width="30" bgcolor="#d4d4d4" height="30"></td>
    <td>#D4D4D4</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#d3d3d3" height="30"></td>
    <td>#D3D3D3</td>
    <td width="30" bgcolor="#d2b48c" height="30"></td>
    <td>#D2B48C</td>
    <td width="30" bgcolor="#d2691e" height="30"></td>
    <td>#D2691E</td>
    <td width="30" bgcolor="#d1eeee" height="30"></td>
    <td>#D1EEEE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#d1d1d1" height="30"></td>
    <td>#D1D1D1</td>
    <td width="30" bgcolor="#d15fee" height="30"></td>
    <td>#D15FEE</td>
    <td width="30" bgcolor="#d02090" height="30"></td>
    <td>#D02090</td>
    <td width="30" bgcolor="#cfcfcf" height="30"></td>
    <td>#CFCFCF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cdcdc1" height="30"></td>
    <td>#CDCDC1</td>
    <td width="30" bgcolor="#cdcdb4" height="30"></td>
    <td>#CDCDB4</td>
    <td width="30" bgcolor="#cdcd00" height="30"></td>
    <td>#CDCD00</td>
    <td width="30" bgcolor="#cdc9c9" height="30"></td>
    <td>#CDC9C9</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cdc9a5" height="30"></td>
    <td>#CDC9A5</td>
    <td width="30" bgcolor="#cdc8b1" height="30"></td>
    <td>#CDC8B1</td>
    <td width="30" bgcolor="#cdc673" height="30"></td>
    <td>#CDC673</td>
    <td width="30" bgcolor="#cdc5bf" height="30"></td>
    <td>#CDC5BF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cdc1c5" height="30"></td>
    <td>#CDC1C5</td>
    <td width="30" bgcolor="#cdc0b0" height="30"></td>
    <td>#CDC0B0</td>
    <td width="30" bgcolor="#cdbe70" height="30"></td>
    <td>#CDBE70</td>
    <td width="30" bgcolor="#cdba96" height="30"></td>
    <td>#CDBA96</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cdb7b5" height="30"></td>
    <td>#CDB7B5</td>
    <td width="30" bgcolor="#cdb79e" height="30"></td>
    <td>#CDB79E</td>
    <td width="30" bgcolor="#cdb5cd" height="30"></td>
    <td>#CDB5CD</td>
    <td width="30" bgcolor="#cdb38b" height="30"></td>
    <td>#CDB38B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cdaf95" height="30"></td>
    <td>#CDAF95</td>
    <td width="30" bgcolor="#cdad00" height="30"></td>
    <td>#CDAD00</td>
    <td width="30" bgcolor="#cdaa7d" height="30"></td>
    <td>#CDAA7D</td>
    <td width="30" bgcolor="#cd9b9b" height="30"></td>
    <td>#CD9B9B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd9b1d" height="30"></td>
    <td>#CD9B1D</td>
    <td width="30" bgcolor="#cd96cd" height="30"></td>
    <td>#CD96CD</td>
    <td width="30" bgcolor="#cd950c" height="30"></td>
    <td>#CD950C</td>
    <td width="30" bgcolor="#cd919e" height="30"></td>
    <td>#CD919E</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd8c95" height="30"></td>
    <td>#CD8C95</td>
    <td width="30" bgcolor="#cd853f" height="30"></td>
    <td>#CD853F</td>
    <td width="30" bgcolor="#cd8500" height="30"></td>
    <td>#CD8500</td>
    <td width="30" bgcolor="#cd8162" height="30"></td>
    <td>#CD8162</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd7054" height="30"></td>
    <td>#CD7054</td>
    <td width="30" bgcolor="#cd69c9" height="30"></td>
    <td>#CD69C9</td>
    <td width="30" bgcolor="#cd6889" height="30"></td>
    <td>#CD6889</td>
    <td width="30" bgcolor="#cd6839" height="30"></td>
    <td>#CD6839</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd661d" height="30"></td>
    <td>#CD661D</td>
    <td width="30" bgcolor="#cd6600" height="30"></td>
    <td>#CD6600</td>
    <td width="30" bgcolor="#cd6090" height="30"></td>
    <td>#CD6090</td>
    <td width="30" bgcolor="#cd5c5c" height="30"></td>
    <td>#CD5C5C</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd5b45" height="30"></td>
    <td>#CD5B45</td>
    <td width="30" bgcolor="#cd5555" height="30"></td>
    <td>#CD5555</td>
    <td width="30" bgcolor="#cd4f39" height="30"></td>
    <td>#CD4F39</td>
    <td width="30" bgcolor="#cd3700" height="30"></td>
    <td>#CD3700</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd3333" height="30"></td>
    <td>#CD3333</td>
    <td width="30" bgcolor="#cd3278" height="30"></td>
    <td>#CD3278</td>
    <td width="30" bgcolor="#cd2990" height="30"></td>
    <td>#CD2990</td>
    <td width="30" bgcolor="#cd2626" height="30"></td>
    <td>#CD2626</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#cd1076" height="30"></td>
    <td>#CD1076</td>
    <td width="30" bgcolor="#cd00cd" height="30"></td>
    <td>#CD00CD</td>
    <td width="30" bgcolor="#cd0000" height="30"></td>
    <td>#CD0000</td>
    <td width="30" bgcolor="#cccccc" height="30"></td>
    <td>#CCCCCC</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#caff70" height="30"></td>
    <td>#CAFF70</td>
    <td width="30" bgcolor="#cae1ff" height="30"></td>
    <td>#CAE1FF</td>
    <td width="30" bgcolor="#c9c9c9" height="30"></td>
    <td>#C9C9C9</td>
    <td width="30" bgcolor="#c7c7c7" height="30"></td>
    <td>#C7C7C7</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#c71585" height="30"></td>
    <td>#C71585</td>
    <td width="30" bgcolor="#c6e2ff" height="30"></td>
    <td>#C6E2FF</td>
    <td width="30" bgcolor="#c67171" height="30"></td>
    <td>#C67171</td>
    <td width="30" bgcolor="#c5c1aa" height="30"></td>
    <td>#C5C1AA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#c4c4c4" height="30"></td>
    <td>#C4C4C4</td>
    <td width="30" bgcolor="#c2c2c2" height="30"></td>
    <td>#C2C2C2</td>
    <td width="30" bgcolor="#c1ffc1" height="30"></td>
    <td>#C1FFC1</td>
    <td width="30" bgcolor="#c1cdcd" height="30"></td>
    <td>#C1CDCD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#c1cdc1" height="30"></td>
    <td>#C1CDC1</td>
    <td width="30" bgcolor="#c1c1c1" height="30"></td>
    <td>#C1C1C1</td>
    <td width="30" bgcolor="#c0ff3e" height="30"></td>
    <td>#C0FF3E</td>
    <td width="30" bgcolor="#bfefff" height="30"></td>
    <td>#BFEFFF</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#bfbfbf" height="30"></td>
    <td>#BFBFBF</td>
    <td width="30" bgcolor="#bf3eff" height="30"></td>
    <td>#BF3EFF</td>
    <td width="30" bgcolor="#bebebe" height="30"></td>
    <td>#BEBEBE</td>
    <td width="30" bgcolor="#bdbdbd" height="30"></td>
    <td>#BDBDBD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#bdb76b" height="30"></td>
    <td>#BDB76B</td>
    <td width="30" bgcolor="#bcee68" height="30"></td>
    <td>#BCEE68</td>
    <td width="30" bgcolor="#bcd2ee" height="30"></td>
    <td>#BCD2EE</td>
    <td width="30" bgcolor="#bc8f8f" height="30"></td>
    <td>#BC8F8F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#bbffff" height="30"></td>
    <td>#BBFFFF</td>
    <td width="30" bgcolor="#bababa" height="30"></td>
    <td>#BABABA</td>
    <td width="30" bgcolor="#ba55d3" height="30"></td>
    <td>#BA55D3</td>
    <td width="30" bgcolor="#b9d3ee" height="30"></td>
    <td>#B9D3EE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#b8b8b8" height="30"></td>
    <td>#B8B8B8</td>
    <td width="30" bgcolor="#b8860b" height="30"></td>
    <td>#B8860B</td>
    <td width="30" bgcolor="#b7b7b7" height="30"></td>
    <td>#B7B7B7</td>
    <td width="30" bgcolor="#b5b5b5" height="30"></td>
    <td>#B5B5B5</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#b4eeb4" height="30"></td>
    <td>#B4EEB4</td>
    <td width="30" bgcolor="#b4cdcd" height="30"></td>
    <td>#B4CDCD</td>
    <td width="30" bgcolor="#b452cd" height="30"></td>
    <td>#B452CD</td>
    <td width="30" bgcolor="#b3ee3a" height="30"></td>
    <td>#B3EE3A</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#b3b3b3" height="30"></td>
    <td>#B3B3B3</td>
    <td width="30" bgcolor="#b2dfee" height="30"></td>
    <td>#B2DFEE</td>
    <td width="30" bgcolor="#b23aee" height="30"></td>
    <td>#B23AEE</td>
    <td width="30" bgcolor="#b22222" height="30"></td>
    <td>#B22222</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#b0e2ff" height="30"></td>
    <td>#B0E2FF</td>
    <td width="30" bgcolor="#b0e0e6" height="30"></td>
    <td>#B0E0E6</td>
    <td width="30" bgcolor="#b0c4de" height="30"></td>
    <td>#B0C4DE</td>
    <td width="30" bgcolor="#b0b0b0" height="30"></td>
    <td>#B0B0B0</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#b03060" height="30"></td>
    <td>#B03060</td>
    <td width="30" bgcolor="#aeeeee" height="30"></td>
    <td>#AEEEEE</td>
    <td width="30" bgcolor="#adff2f" height="30"></td>
    <td>#ADFF2F</td>
    <td width="30" bgcolor="#add8e6" height="30"></td>
    <td>#ADD8E6</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#adadad" height="30"></td>
    <td>#ADADAD</td>
    <td width="30" bgcolor="#ababab" height="30"></td>
    <td>#ABABAB</td>
    <td width="30" bgcolor="#ab82ff" height="30"></td>
    <td>#AB82FF</td>
    <td width="30" bgcolor="#aaaaaa" height="30"></td>
    <td>#AAAAAA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#a9a9a9" height="30"></td>
    <td>#A9A9A9</td>
    <td width="30" bgcolor="#a8a8a8" height="30"></td>
    <td>#A8A8A8</td>
    <td width="30" bgcolor="#a6a6a6" height="30"></td>
    <td>#A6A6A6</td>
    <td width="30" bgcolor="#a52a2a" height="30"></td>
    <td>#A52A2A</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#a4d3ee" height="30"></td>
    <td>#A4D3EE</td>
    <td width="30" bgcolor="#a3a3a3" height="30"></td>
    <td>#A3A3A3</td>
    <td width="30" bgcolor="#a2cd5a" height="30"></td>
    <td>#A2CD5A</td>
    <td width="30" bgcolor="#a2b5cd" height="30"></td>
    <td>#A2B5CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#a1a1a1" height="30"></td>
    <td>#A1A1A1</td>
    <td width="30" bgcolor="#a0522d" height="30"></td>
    <td>#A0522D</td>
    <td width="30" bgcolor="#a020f0" height="30"></td>
    <td>#A020F0</td>
    <td width="30" bgcolor="#9fb6cd" height="30"></td>
    <td>#9FB6CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#9f79ee" height="30"></td>
    <td>#9F79EE</td>
    <td width="30" bgcolor="#9e9e9e" height="30"></td>
    <td>#9E9E9E</td>
    <td width="30" bgcolor="#9c9c9c" height="30"></td>
    <td>#9C9C9C</td>
    <td width="30" bgcolor="#9bcd9b" height="30"></td>
    <td>#9BCD9B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#9b30ff" height="30"></td>
    <td>#9B30FF</td>
    <td width="30" bgcolor="#9aff9a" height="30"></td>
    <td>#9AFF9A</td>
    <td width="30" bgcolor="#9acd32" height="30"></td>
    <td>#9ACD32</td>
    <td width="30" bgcolor="#9ac0cd" height="30"></td>
    <td>#9AC0CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#9a32cd" height="30"></td>
    <td>#9A32CD</td>
    <td width="30" bgcolor="#999999" height="30"></td>
    <td>#999999</td>
    <td width="30" bgcolor="#9932cc" height="30"></td>
    <td>#9932CC</td>
    <td width="30" bgcolor="#98fb98" height="30"></td>
    <td>#98FB98</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#98f5ff" height="30"></td>
    <td>#98F5FF</td>
    <td width="30" bgcolor="#97ffff" height="30"></td>
    <td>#97FFFF</td>
    <td width="30" bgcolor="#96cdcd" height="30"></td>
    <td>#96CDCD</td>
    <td width="30" bgcolor="#969696" height="30"></td>
    <td>#969696</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#949494" height="30"></td>
    <td>#949494</td>
    <td width="30" bgcolor="#9400d3" height="30"></td>
    <td>#9400D3</td>
    <td width="30" bgcolor="#9370db" height="30"></td>
    <td>#9370DB</td>
    <td width="30" bgcolor="#919191" height="30"></td>
    <td>#919191</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#912cee" height="30"></td>
    <td>#912CEE</td>
    <td width="30" bgcolor="#90ee90" height="30"></td>
    <td>#90EE90</td>
    <td width="30" bgcolor="#8fbc8f" height="30"></td>
    <td>#8FBC8F</td>
    <td width="30" bgcolor="#8f8f8f" height="30"></td>
    <td>#8F8F8F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8ee5ee" height="30"></td>
    <td>#8EE5EE</td>
    <td width="30" bgcolor="#8e8e8e" height="30"></td>
    <td>#8E8E8E</td>
    <td width="30" bgcolor="#8e8e38" height="30"></td>
    <td>#8E8E38</td>
    <td width="30" bgcolor="#8e388e" height="30"></td>
    <td>#8E388E</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8deeee" height="30"></td>
    <td>#8DEEEE</td>
    <td width="30" bgcolor="#8db6cd" height="30"></td>
    <td>#8DB6CD</td>
    <td width="30" bgcolor="#8c8c8c" height="30"></td>
    <td>#8C8C8C</td>
    <td width="30" bgcolor="#8b8b83" height="30"></td>
    <td>#8B8B83</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b8b7a" height="30"></td>
    <td>#8B8B7A</td>
    <td width="30" bgcolor="#8b8b00" height="30"></td>
    <td>#8B8B00</td>
    <td width="30" bgcolor="#8b8989" height="30"></td>
    <td>#8B8989</td>
    <td width="30" bgcolor="#8b8970" height="30"></td>
    <td>#8B8970</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b8878" height="30"></td>
    <td>#8B8878</td>
    <td width="30" bgcolor="#8b8682" height="30"></td>
    <td>#8B8682</td>
    <td width="30" bgcolor="#8b864e" height="30"></td>
    <td>#8B864E</td>
    <td width="30" bgcolor="#8b8386" height="30"></td>
    <td>#8B8386</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b8378" height="30"></td>
    <td>#8B8378</td>
    <td width="30" bgcolor="#8b814c" height="30"></td>
    <td>#8B814C</td>
    <td width="30" bgcolor="#8b7e66" height="30"></td>
    <td>#8B7E66</td>
    <td width="30" bgcolor="#8b7d7b" height="30"></td>
    <td>#8B7D7B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b7d6b" height="30"></td>
    <td>#8B7D6B</td>
    <td width="30" bgcolor="#8b7b8b" height="30"></td>
    <td>#8B7B8B</td>
    <td width="30" bgcolor="#8b795e" height="30"></td>
    <td>#8B795E</td>
    <td width="30" bgcolor="#8b7765" height="30"></td>
    <td>#8B7765</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b7500" height="30"></td>
    <td>#8B7500</td>
    <td width="30" bgcolor="#8b7355" height="30"></td>
    <td>#8B7355</td>
    <td width="30" bgcolor="#8b6969" height="30"></td>
    <td>#8B6969</td>
    <td width="30" bgcolor="#8b6914" height="30"></td>
    <td>#8B6914</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b668b" height="30"></td>
    <td>#8B668B</td>
    <td width="30" bgcolor="#8b6508" height="30"></td>
    <td>#8B6508</td>
    <td width="30" bgcolor="#8b636c" height="30"></td>
    <td>#8B636C</td>
    <td width="30" bgcolor="#8b5f65" height="30"></td>
    <td>#8B5F65</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b5a2b" height="30"></td>
    <td>#8B5A2B</td>
    <td width="30" bgcolor="#8b5a00" height="30"></td>
    <td>#8B5A00</td>
    <td width="30" bgcolor="#8b5742" height="30"></td>
    <td>#8B5742</td>
    <td width="30" bgcolor="#8b4c39" height="30"></td>
    <td>#8B4C39</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b4789" height="30"></td>
    <td>#8B4789</td>
    <td width="30" bgcolor="#8b475d" height="30"></td>
    <td>#8B475D</td>
    <td width="30" bgcolor="#8b4726" height="30"></td>
    <td>#8B4726</td>
    <td width="30" bgcolor="#8b4513" height="30"></td>
    <td>#8B4513</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b4500" height="30"></td>
    <td>#8B4500</td>
    <td width="30" bgcolor="#8b3e2f" height="30"></td>
    <td>#8B3E2F</td>
    <td width="30" bgcolor="#8b3a62" height="30"></td>
    <td>#8B3A62</td>
    <td width="30" bgcolor="#8b3a3a" height="30"></td>
    <td>#8B3A3A</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b3626" height="30"></td>
    <td>#8B3626</td>
    <td width="30" bgcolor="#8b2500" height="30"></td>
    <td>#8B2500</td>
    <td width="30" bgcolor="#8b2323" height="30"></td>
    <td>#8B2323</td>
    <td width="30" bgcolor="#8b2252" height="30"></td>
    <td>#8B2252</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b1c62" height="30"></td>
    <td>#8B1C62</td>
    <td width="30" bgcolor="#8b1a1a" height="30"></td>
    <td>#8B1A1A</td>
    <td width="30" bgcolor="#8b0a50" height="30"></td>
    <td>#8B0A50</td>
    <td width="30" bgcolor="#8b008b" height="30"></td>
    <td>#8B008B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#8b0000" height="30"></td>
    <td>#8B0000</td>
    <td width="30" bgcolor="#8a8a8a" height="30"></td>
    <td>#8A8A8A</td>
    <td width="30" bgcolor="#8a2be2" height="30"></td>
    <td>#8A2BE2</td>
    <td width="30" bgcolor="#8968cd" height="30"></td>
    <td>#8968CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#87ceff" height="30"></td>
    <td>#87CEFF</td>
    <td width="30" bgcolor="#87cefa" height="30"></td>
    <td>#87CEFA</td>
    <td width="30" bgcolor="#87ceeb" height="30"></td>
    <td>#87CEEB</td>
    <td width="30" bgcolor="#878787" height="30"></td>
    <td>#878787</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#858585" height="30"></td>
    <td>#858585</td>
    <td width="30" bgcolor="#848484" height="30"></td>
    <td>#848484</td>
    <td width="30" bgcolor="#8470ff" height="30"></td>
    <td>#8470FF</td>
    <td width="30" bgcolor="#838b8b" height="30"></td>
    <td>#838B8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#838b83" height="30"></td>
    <td>#838B83</td>
    <td width="30" bgcolor="#836fff" height="30"></td>
    <td>#836FFF</td>
    <td width="30" bgcolor="#828282" height="30"></td>
    <td>#828282</td>
    <td width="30" bgcolor="#7fffd4" height="30"></td>
    <td>#7FFFD4</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#7fff00" height="30"></td>
    <td>#7FFF00</td>
    <td width="30" bgcolor="#7f7f7f" height="30"></td>
    <td>#7F7F7F</td>
    <td width="30" bgcolor="#7ec0ee" height="30"></td>
    <td>#7EC0EE</td>
    <td width="30" bgcolor="#7d9ec0" height="30"></td>
    <td>#7D9EC0</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#7d7d7d" height="30"></td>
    <td>#7D7D7D</td>
    <td width="30" bgcolor="#7d26cd" height="30"></td>
    <td>#7D26CD</td>
    <td width="30" bgcolor="#7cfc00" height="30"></td>
    <td>#7CFC00</td>
    <td width="30" bgcolor="#7ccd7c" height="30"></td>
    <td>#7CCD7C</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#7b68ee" height="30"></td>
    <td>#7B68EE</td>
    <td width="30" bgcolor="#7ac5cd" height="30"></td>
    <td>#7AC5CD</td>
    <td width="30" bgcolor="#7a8b8b" height="30"></td>
    <td>#7A8B8B</td>
    <td width="30" bgcolor="#7a7a7a" height="30"></td>
    <td>#7A7A7A</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#7a67ee" height="30"></td>
    <td>#7A67EE</td>
    <td width="30" bgcolor="#7a378b" height="30"></td>
    <td>#7A378B</td>
    <td width="30" bgcolor="#79cdcd" height="30"></td>
    <td>#79CDCD</td>
    <td width="30" bgcolor="#787878" height="30"></td>
    <td>#787878</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#778899" height="30"></td>
    <td>#778899</td>
    <td width="30" bgcolor="#76eec6" height="30"></td>
    <td>#76EEC6</td>
    <td width="30" bgcolor="#76ee00" height="30"></td>
    <td>#76EE00</td>
    <td width="30" bgcolor="#757575" height="30"></td>
    <td>#757575</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#737373" height="30"></td>
    <td>#737373</td>
    <td width="30" bgcolor="#71c671" height="30"></td>
    <td>#71C671</td>
    <td width="30" bgcolor="#7171c6" height="30"></td>
    <td>#7171C6</td>
    <td width="30" bgcolor="#708090" height="30"></td>
    <td>#708090</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#707070" height="30"></td>
    <td>#707070</td>
    <td width="30" bgcolor="#6e8b3d" height="30"></td>
    <td>#6E8B3D</td>
    <td width="30" bgcolor="#6e7b8b" height="30"></td>
    <td>#6E7B8B</td>
    <td width="30" bgcolor="#6e6e6e" height="30"></td>
    <td>#6E6E6E</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#6ca6cd" height="30"></td>
    <td>#6CA6CD</td>
    <td width="30" bgcolor="#6c7b8b" height="30"></td>
    <td>#6C7B8B</td>
    <td width="30" bgcolor="#6b8e23" height="30"></td>
    <td>#6B8E23</td>
    <td width="30" bgcolor="#6b6b6b" height="30"></td>
    <td>#6B6B6B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#6a5acd" height="30"></td>
    <td>#6A5ACD</td>
    <td width="30" bgcolor="#698b69" height="30"></td>
    <td>#698B69</td>
    <td width="30" bgcolor="#698b22" height="30"></td>
    <td>#698B22</td>
    <td width="30" bgcolor="#696969" height="30"></td>
    <td>#696969</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#6959cd" height="30"></td>
    <td>#6959CD</td>
    <td width="30" bgcolor="#68838b" height="30"></td>
    <td>#68838B</td>
    <td width="30" bgcolor="#68228b" height="30"></td>
    <td>#68228B</td>
    <td width="30" bgcolor="#66cdaa" height="30"></td>
    <td>#66CDAA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#66cd00" height="30"></td>
    <td>#66CD00</td>
    <td width="30" bgcolor="#668b8b" height="30"></td>
    <td>#668B8B</td>
    <td width="30" bgcolor="#666666" height="30"></td>
    <td>#666666</td>
    <td width="30" bgcolor="#6495ed" height="30"></td>
    <td>#6495ED</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#63b8ff" height="30"></td>
    <td>#63B8FF</td>
    <td width="30" bgcolor="#636363" height="30"></td>
    <td>#636363</td>
    <td width="30" bgcolor="#616161" height="30"></td>
    <td>#616161</td>
    <td width="30" bgcolor="#607b8b" height="30"></td>
    <td>#607B8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#5f9ea0" height="30"></td>
    <td>#5F9EA0</td>
    <td width="30" bgcolor="#5e5e5e" height="30"></td>
    <td>#5E5E5E</td>
    <td width="30" bgcolor="#5d478b" height="30"></td>
    <td>#5D478B</td>
    <td width="30" bgcolor="#5cacee" height="30"></td>
    <td>#5CACEE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#5c5c5c" height="30"></td>
    <td>#5C5C5C</td>
    <td width="30" bgcolor="#5b5b5b" height="30"></td>
    <td>#5B5B5B</td>
    <td width="30" bgcolor="#595959" height="30"></td>
    <td>#595959</td>
    <td width="30" bgcolor="#575757" height="30"></td>
    <td>#575757</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#556b2f" height="30"></td>
    <td>#556B2F</td>
    <td width="30" bgcolor="#555555" height="30"></td>
    <td>#555555</td>
    <td width="30" bgcolor="#551a8b" height="30"></td>
    <td>#551A8B</td>
    <td width="30" bgcolor="#54ff9f" height="30"></td>
    <td>#54FF9F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#548b54" height="30"></td>
    <td>#548B54</td>
    <td width="30" bgcolor="#545454" height="30"></td>
    <td>#545454</td>
    <td width="30" bgcolor="#53868b" height="30"></td>
    <td>#53868B</td>
    <td width="30" bgcolor="#528b8b" height="30"></td>
    <td>#528B8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#525252" height="30"></td>
    <td>#525252</td>
    <td width="30" bgcolor="#515151" height="30"></td>
    <td>#515151</td>
    <td width="30" bgcolor="#4f94cd" height="30"></td>
    <td>#4F94CD</td>
    <td width="30" bgcolor="#4f4f4f" height="30"></td>
    <td>#4F4F4F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#4eee94" height="30"></td>
    <td>#4EEE94</td>
    <td width="30" bgcolor="#4d4d4d" height="30"></td>
    <td>#4D4D4D</td>
    <td width="30" bgcolor="#4b0082" height="30"></td>
    <td>#4B0082</td>
    <td width="30" bgcolor="#4a708b" height="30"></td>
    <td>#4A708B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#4a4a4a" height="30"></td>
    <td>#4A4A4A</td>
    <td width="30" bgcolor="#48d1cc" height="30"></td>
    <td>#48D1CC</td>
    <td width="30" bgcolor="#4876ff" height="30"></td>
    <td>#4876FF</td>
    <td width="30" bgcolor="#483d8b" height="30"></td>
    <td>#483D8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#474747" height="30"></td>
    <td>#474747</td>
    <td width="30" bgcolor="#473c8b" height="30"></td>
    <td>#473C8B</td>
    <td width="30" bgcolor="#4682b4" height="30"></td>
    <td>#4682B4</td>
    <td width="30" bgcolor="#458b74" height="30"></td>
    <td>#458B74</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#458b00" height="30"></td>
    <td>#458B00</td>
    <td width="30" bgcolor="#454545" height="30"></td>
    <td>#454545</td>
    <td width="30" bgcolor="#43cd80" height="30"></td>
    <td>#43CD80</td>
    <td width="30" bgcolor="#436eee" height="30"></td>
    <td>#436EEE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#424242" height="30"></td>
    <td>#424242</td>
    <td width="30" bgcolor="#4169e1" height="30"></td>
    <td>#4169E1</td>
    <td width="30" bgcolor="#40e0d0" height="30"></td>
    <td>#40E0D0</td>
    <td width="30" bgcolor="#404040" height="30"></td>
    <td>#404040</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#3d3d3d" height="30"></td>
    <td>#3D3D3D</td>
    <td width="30" bgcolor="#3cb371" height="30"></td>
    <td>#3CB371</td>
    <td width="30" bgcolor="#3b3b3b" height="30"></td>
    <td>#3B3B3B</td>
    <td width="30" bgcolor="#3a5fcd" height="30"></td>
    <td>#3A5FCD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#388e8e" height="30"></td>
    <td>#388E8E</td>
    <td width="30" bgcolor="#383838" height="30"></td>
    <td>#383838</td>
    <td width="30" bgcolor="#36648b" height="30"></td>
    <td>#36648B</td>
    <td width="30" bgcolor="#363636" height="30"></td>
    <td>#363636</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#333333" height="30"></td>
    <td>#333333</td>
    <td width="30" bgcolor="#32cd32" height="30"></td>
    <td>#32CD32</td>
    <td width="30" bgcolor="#303030" height="30"></td>
    <td>#303030</td>
    <td width="30" bgcolor="#2f4f4f" height="30"></td>
    <td>#2F4F4F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#2e8b57" height="30"></td>
    <td>#2E8B57</td>
    <td width="30" bgcolor="#2e2e2e" height="30"></td>
    <td>#2E2E2E</td>
    <td width="30" bgcolor="#2b2b2b" height="30"></td>
    <td>#2B2B2B</td>
    <td width="30" bgcolor="#292929" height="30"></td>
    <td>#292929</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#282828" height="30"></td>
    <td>#282828</td>
    <td width="30" bgcolor="#27408b" height="30"></td>
    <td>#27408B</td>
    <td width="30" bgcolor="#262626" height="30"></td>
    <td>#262626</td>
    <td width="30" bgcolor="#242424" height="30"></td>
    <td>#242424</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#228b22" height="30"></td>
    <td>#228B22</td>
    <td width="30" bgcolor="#218868" height="30"></td>
    <td>#218868</td>
    <td width="30" bgcolor="#212121" height="30"></td>
    <td>#212121</td>
    <td width="30" bgcolor="#20b2aa" height="30"></td>
    <td>#20B2AA</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#1f1f1f" height="30"></td>
    <td>#1F1F1F</td>
    <td width="30" bgcolor="#1e90ff" height="30"></td>
    <td>#1E90FF</td>
    <td width="30" bgcolor="#1e1e1e" height="30"></td>
    <td>#1E1E1E</td>
    <td width="30" bgcolor="#1c86ee" height="30"></td>
    <td>#1C86EE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#1c1c1c" height="30"></td>
    <td>#1C1C1C</td>
    <td width="30" bgcolor="#1a1a1a" height="30"></td>
    <td>#1A1A1A</td>
    <td width="30" bgcolor="#191970" height="30"></td>
    <td>#191970</td>
    <td width="30" bgcolor="#1874cd" height="30"></td>
    <td>#1874CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#171717" height="30"></td>
    <td>#171717</td>
    <td width="30" bgcolor="#141414" height="30"></td>
    <td>#141414</td>
    <td width="30" bgcolor="#121212" height="30"></td>
    <td>#121212</td>
    <td width="30" bgcolor="#104e8b" height="30"></td>
    <td>#104E8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#0f0f0f" height="30"></td>
    <td>#0F0F0F</td>
    <td width="30" bgcolor="#0d0d0d" height="30"></td>
    <td>#0D0D0D</td>
    <td width="30" bgcolor="#0a0a0a" height="30"></td>
    <td>#0A0A0A</td>
    <td width="30" bgcolor="#080808" height="30"></td>
    <td>#080808</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#050505" height="30"></td>
    <td>#050505</td>
    <td width="30" bgcolor="#030303" height="30"></td>
    <td>#030303</td>
    <td width="30" bgcolor="#00ffff" height="30"></td>
    <td>#00FFFF</td>
    <td width="30" bgcolor="#00ff7f" height="30"></td>
    <td>#00FF7F</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#00ff00" height="30"></td>
    <td>#00FF00</td>
    <td width="30" bgcolor="#00fa9a" height="30"></td>
    <td>#00FA9A</td>
    <td width="30" bgcolor="#00f5ff" height="30"></td>
    <td>#00F5FF</td>
    <td width="30" bgcolor="#00eeee" height="30"></td>
    <td>#00EEEE</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#00ee76" height="30"></td>
    <td>#00EE76</td>
    <td width="30" bgcolor="#00ee00" height="30"></td>
    <td>#00EE00</td>
    <td width="30" bgcolor="#00e5ee" height="30"></td>
    <td>#00E5EE</td>
    <td width="30" bgcolor="#00ced1" height="30"></td>
    <td>#00CED1</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#00cdcd" height="30"></td>
    <td>#00CDCD</td>
    <td width="30" bgcolor="#00cd66" height="30"></td>
    <td>#00CD66</td>
    <td width="30" bgcolor="#00cd00" height="30"></td>
    <td>#00CD00</td>
    <td width="30" bgcolor="#00c5cd" height="30"></td>
    <td>#00C5CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#00bfff" height="30"></td>
    <td>#00BFFF</td>
    <td width="30" bgcolor="#00b2ee" height="30"></td>
    <td>#00B2EE</td>
    <td width="30" bgcolor="#009acd" height="30"></td>
    <td>#009ACD</td>
    <td width="30" bgcolor="#008b8b" height="30"></td>
    <td>#008B8B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#008b45" height="30"></td>
    <td>#008B45</td>
    <td width="30" bgcolor="#008b00" height="30"></td>
    <td>#008B00</td>
    <td width="30" bgcolor="#00868b" height="30"></td>
    <td>#00868B</td>
    <td width="30" bgcolor="#00688b" height="30"></td>
    <td>#00688B</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#006400" height="30"></td>
    <td>#006400</td>
    <td width="30" bgcolor="#0000ff" height="30"></td>
    <td>#0000FF</td>
    <td width="30" bgcolor="#0000ee" height="30"></td>
    <td>#0000EE</td>
    <td width="30" bgcolor="#0000cd" height="30"></td>
    <td>#0000CD</td>
  </tr>
  <tr>
    <td width="30" bgcolor="#0000aa" height="30"></td>
    <td>#0000AA</td>
    <td width="30" bgcolor="#00008b" height="30"></td>
    <td>#00008B</td>
    <td width="30" bgcolor="#000080" height="30"></td>
    <td>#000080</td>
    <td width="30" bgcolor="#000000" height="30"></td>
    <td>#000000</td>
  </tr>
</tbody></table>