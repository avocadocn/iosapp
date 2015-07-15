'use strict';

var LinkageSelector;

(function() {


    /**
     * 联动菜单构造函数
     * @param element 包含selects的DOM对象
     * @param onchange 选择一个选项后调用的回调函数, onchange(selectValues, selectIndexes)
     * @constructor
     */
    LinkageSelector = function (element, onchange) {

        /**
         * 根据data-select获取element中select的name
         * @type {Array}
         */
        var selectNames = element.dataset.select.split(' ');


        /**
         * 根据select的name查询DOM获取select对象
         * @type {Array}
         */
        var selects = selectNames.map(function (name) {
            return element.querySelector('[name=' + name + ']');
        });


        /**
         * 每个select当前被选择的option的索引
         * @type {Array}
         */
        var selectIndexes = [];
        for (var i = 0; i < selects.length; i++) {
            selectIndexes.push(0);
        }


        /**
         * 数据源
         * @type {string}
         */
        var dataSrc = element.dataset.src;


        /**
         * 根据数据源请求的数据
         * @type {Array}
         */
        var data = [];


        /**
         * 根据当前的选择，获取某一层的数据
         * @param layer
         * @returns {Array} 返回[{label, value, data}]格式数据
         */
        var getData = function (layer) {
            var tempData = data;
            for (var i = 0; i < layer; i++) {
                tempData = tempData[selectIndexes[i]].data;
            }
            return tempData;
        };


        /**
         * 设置select元素的option
         * @param select select元素的DOM对象
         * @param data [{label: String, value: String}]
         * @param index 初始状态是选择第几项（从0开始，默认为0）
         */
        var setOptions = function (select, data, index) {
            select.innerHTML = '';
            for (var i = 0; i < data.length; i++) {

                var option = document.createElement('option');
                option.value = data[i].value;
                if (data[i].label) {
                    option.innerHTML = data[i].label;
                } else {
                    option.innerHTML = option.value;
                }

                select.appendChild(option);
            }
            select.selectedIndex = index | 0;
            select.value = data[index].value;
        };


        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function () {

            if (xhr.readyState === 4 && xhr.status === 200) {
                data = JSON.parse(xhr.responseText).data;

                if (element.dataset.init) {
                    var initValue = element.dataset.init.split(' ');
                    for (var i = 0; i < initValue.length; i++) {
                        var initData = getData(i);
                        for (var j = 0; j < initData.length; j++) {
                            if (initValue[i] === initData[j].value) {
                                selectIndexes[i] = j;
                                break;
                            }
                        }
                    }

                }

                for (var i = 0; i < selects.length; i++) {
                    var optionData = getData(i);
                    setOptions(selects[i], optionData, selectIndexes[i]);

                    if (i < selects.length - 1) {
                        selects[i].onchange = (function (i) {
                            return function() {
                                var select = this;
                                var thisData = getData(i);
                                for (var j = 0; j < thisData.length; j++) {
                                    if (select.value === thisData[j].value) {
                                        selectIndexes[i] = j;
                                        setOptions(selects[i + 1], getData(i + 1), 0);

                                        if (i < selects.length - 2) {
                                            selects[i + 1].onchange();
                                        } else {
                                            var selectValues = selects.map(function(select) {
                                                return select.value;
                                            });
                                            onchange && onchange(selectValues, selectIndexes);
                                        }

                                    }
                                }
                            };

                        })(i);
                    } else if (i === selects.length - 1) {
                        selects[i].onchange = function() {
                            var select = this;
                            var selectValues = selects.map(function(select) {
                                return select.value;
                            });
                            onchange && onchange(selectValues, selectIndexes);
                        }
                    }


                }


            }
        };

        xhr.open('GET', dataSrc, true);
        xhr.send();

    };



    /**
     * 页面中所有的linkage-selector
     * @type {NodeList}
     */
    var selectors = document.querySelectorAll('[data-role=linkage-selector]');

    // 初始化所有linkage-selector
    for (var i = 0; i < selectors.length; i++) {
        new LinkageSelector(selectors[i]);
    }


}());

