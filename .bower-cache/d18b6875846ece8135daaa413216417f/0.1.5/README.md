linkage-selector
================

html5 + js 联动菜单

#优点
__无依赖项__ : 使用原生js编写，不依赖任何框架
__不限制级数__ : 可以是2级、3级、4级等多级联动菜单

#浏览器支持

IE10+及各大主流浏览器(Chrome, FireFox, Safari, Opera)的最新的几个版本。

#使用方法

使用方法非常简单，您只需要3步:
##1.设置三个参数。
- __data-role__ : 将其设为 linkage-selector 即可
- __data-src__ : json数据文件地址
- __data-select__ : 联动菜单中用到的select的name属性，用空格符分隔，先后顺序决定触发事件。例如下面的例子，选择province的option会触发city的option列表的改变。
```html
<div data-role="linkage-selector" data-src="provinces.json" data-select="province city">
    <select name="province"></select>
    <select name="city"></select>
</div>
```

##2.然后在html文件`</body>`之前添加：
```html
<script src="linkage-selector.js"></script>
```

##3.最后准备一个json文件存放数据(label是option的显示文字，value是option的值，两者可以不相同)：
```json
{
    "data": [
        {
            "label": "上海",
            "value": "上海",
            "data": [
                { "label": "宝山", "value": "宝山" },
                { "label": "黄浦", "value": "黄浦" }
            ]
        },
        {
            "label": "广西",
            "value": "广西",
            "data": [
                { "label": "南宁", "value": "南宁" },
                { "label": "梧州", "value": "梧州" }
            ]
        }
    ]
}
```


#其它参数

##初始化选项
- __data-init__ : 设置初始选项，其值为option的value值序列，如

```html
<div data-role="linkage-selector" data-src="provinces.json" data-select="province city" data-init="广西 南宁">
    <select name="province"></select>
    <select name="city"></select>
</div>
```

##构造函数
您还可以省略data-role参数，使用构造函数动态创建联动菜单。
```html
<div id="test" data-src="provinces.json" data-select="province city">
    <select name="province"></select>
    <select name="city"></select>
</div>
```

再添加如下代码
```javascript
var selector = new LinkageSelector(document.getElementById('test'));
```

##回调函数
您可以通过回调函数，获取联动菜单在onchange事件之后的值，这在和AngularJS配合使用的时候比较管用。
```javascript
var selector = new LinkageSelector(document.getElementById('test'), function(selectValues, selectIndexes) {
    // selectValues 是一个数组，数组元素为联动菜单每个select的value
    // selectIndexes 是一个数组，数组元素为联动菜单每个select的selectIndex
});
```

##省略数据label
也可以省去label属性，此时用value作为option的显示文字。

```json
{
    "data": [
        {
            "value": "上海",
            "data": [
                { "value": "宝山" },
                { "value": "黄浦" }
            ]
        },
        {
            "value": "广西",
            "data": [
                { "value": "南宁" },
                { "value": "梧州" }
            ]
        }
    ]
}
```

OK,就这么简单。请在服务器环境下使用。如果还有疑问，可以参考[示例](https://github.com/CahaVar/linkage-selector/tree/master/example)。