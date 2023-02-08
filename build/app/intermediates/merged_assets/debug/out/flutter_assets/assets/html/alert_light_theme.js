$(function () {
    Highcharts.theme = {
        chart: {
            backgroundColor: 'rgba(255,255, 255, 1.0)',
            style: {
                fontFamily: '\'Roboto\', sans-serif'
            },
            plotBorderColor: '#606063',
            reflow: true,
            // height: 300,
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        title: {
            style: {
                color: '#000000',
                textTransform: 'uppercase',
                fontSize: '14px'
            },
            text: undefined
        },
        subtitle: {
            style: {
                color: '#000000',
                textTransform: 'uppercase'
            },
            text: undefined
        },
        xAxis: {
            text: undefined,
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: '#000000'
                },
            },
            title: {
                text: undefined,
                style: {
                    color: '#000000'
                },
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: '#000000'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            tickWidth: 1,
            title: {
                text: undefined
            }
        },
        tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.85)',
            style: {
                color: '#F0F0F0'
            },
        },
        plotOptions: {
            series: {
                turboThreshold: 0,
                dataLabels: {
                    color: '#F0F0F3',
                    style: {
                        fontSize: '13px'
                    }
                },
                marker: {
                    lineColor: '#333'
                }
            },
            boxplot: {
                fillColor: '#505053'
            },
            candlestick: {
                lineColor: 'white'
            },
            errorbar: {
                color: 'white'
            },
            borderColor: 'transparent'
        },
        legend: {
            align: 'left',
            verticalAlign: 'top',
            floating: false,
            x: 0,
            y: 0,
            symbolHeight: 10,
            backgroundColor: 'rgba(0, 0, 0, 0.0)',
            borderColor: '#ffffff',
            borderWidth: 0,
            itemStyle: {
                color: '#000000',
                fontSize: '13',
            },
            itemHoverStyle: {
                color: '#B1B1B1',
                fontSize: '13',
            },
            itemHiddenStyle: {
                color: '#B1B1B1',
                fontSize: '13',
            },
            title: {
                style: {
                    color: '#000000',
                    fontSize: '13'
                }
            }
        },
        credits: {
            style: {
                color: '#000000',
                fontSize: '11px'
            }
        },
        labels: {
            style: {
                color: '#707073'
            }
        },
        drilldown: {
            activeAxisLabelStyle: {
                color: '#F0F0F3'
            },
            activeDataLabelStyle: {
                color: '#F0F0F3'
            }
        },
        navigation: {
            buttonOptions: {
                symbolStroke: '#DDDDDD',
                theme: {
                    fill: '#505053'
                }
            }
        },
        // scroll charts
        rangeSelector: {
            buttonTheme: {
                fill: '#505053',
                stroke: '#000000',
                style: {
                    color: '#CCC'
                },
                states: {
                    hover: {
                        fill: '#707073',
                        stroke: '#000000',
                        style: {
                            color: 'white'
                        }
                    },
                    select: {
                        fill: '#000003',
                        stroke: '#000000',
                        style: {
                            color: 'white'
                        }
                    }
                }
            },
            inputBoxBorderColor: '#505053',
            inputStyle: {
                backgroundColor: '#333',
                color: 'silver'
            },
            labelStyle: {
                color: 'silver'
            }
        },
        navigator: {
            handles: {
                backgroundColor: '#666',
                borderColor: '#AAA'
            },
            outlineColor: '#CCC',
            maskFill: 'rgba(255,255,255,0.1)',
            series: {
                color: '#7798BF',
                lineColor: '#A6C7ED'
            },
            xAxis: {
                gridLineColor: '#505053'
            }
        },
        scrollbar: {
            barBackgroundColor: '#808083',
            barBorderColor: '#808083',
            buttonArrowColor: '#CCC',
            buttonBackgroundColor: '#606063',
            buttonBorderColor: '#606063',
            rifleColor: '#FFF',
            trackBackgroundColor: '#404043',
            trackBorderColor: '#404043'
        },
        responsive: {
            rules: [{
                condition: {
                    minWidth: 600,
                }
            }]
        },
        exporting: {
            enabled: false
        }
    };
    // Apply the theme
    Highcharts.setOptions(Highcharts.theme);
    AlertChannel.postMessage("");
});
chart1 = null;
chart2 = null;

function exportImage() {
    if (chart1 != undefined && chart1 != null) {
        var svg = chart1.getSVG();
        DQMExportImageChannel.postMessage(svg);
        // DQMExportImageChannel.postMessage('############ exportImage');
    }
    if (chart2 != undefined && chart1 != null) {
        var svg = chart2.getSVG();
        DQMExportImageChannel.postMessage(svg);
        // DQMExportImageChannel.postMessage('############ exportImage');
    }
    // if ( probeHeatMap != undefined) {
    //     var svg = probeHeatMap.getSVG();

    //     DQMExportImageChannel.postMessage(svg);
    // }
    DQMExportImageChannel.postMessage('############ exportImage');


}


function exportPDF() {
    if (chart1 != null && chart1 != undefined) {
        DQMExportPDFChannel.postMessage(chart1.getSVG());
    }
}



function fetchAlertStatisticsDetailData(...params) {
    var highData = [];
    var mediumData = [];
    var lowData = [];
    var otherData = [];

    params[0].map(function (row) {
        if (row.alertSeverity != null && row.alertSeverity.length > 0) {
            if (row.alertSeverity.match("High")) {
                highData.push([row.alertType, row.alertCount]);
            }

            else if (row.alertSeverity.match("Medium")) {
                mediumData.push([row.alertType, row.alertCount]);
            }

            else if (row.alertSeverity.match("Low")) {
                lowData.push([row.alertType, row.alertCount]);
            }
        }
        else {
            otherData.push([row.alertType, row.alertCount]);
        }

    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            height: 600,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            title: {
                text: null
            },
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var xLable = this.value;
                    if (this.value.startsWith("DUT")) {
                        xLable = this.value.substring(3);
                    }
                    var newStr =
                        xLable
                            // insert a space before all caps
                            .replace(/([A-Z])/g, ' $1')
                            // uppercase the first character
                            .replace(/^./, function (str) { return str.toUpperCase(); });
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[5],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            bar: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointWidth: 25,
                events: {
                    click: function (event) {
                        AlertClickChannel.postMessage(event.point.name);
                    }
                }
            },
        },
        series: [{
            name:params[1],
            data: highData,
            color: '#e3032a'
        },
        {
            name:params[2],
            data: mediumData,
            color: '#f66a01',
        },
        {
            name:params[3],
            data: lowData,
            color: '#EDD043'
        },
        {
            name:params[4],
            data: otherData,
            color: '#ffffff'
        }]
    });
}

function fetchPreferedAlertStatisticsDetailData(...params) {
    var highData = [];
    var mediumData = [];
    var lowData = [];
    var otherData = [];

    const map1 = new Map(Object.entries(params[0]));
    for (let [key, value] of map1.entries()) {
        highData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("High");
        }).length]);

        mediumData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("Medium");
        }).length]);

        lowData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("Low");
        }).length]);

        otherData.push([key, value.filter(function (mData) {
            return mData.alertSeverity == null || mData.alertSeverity.length == 0;
        }).length]);
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            height: 600,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            title: {
                text: null
            },
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var xLable = this.value;
                    if (this.value.startsWith("DUT")) {
                        xLable = this.value.substring(3);
                    }
                    var newStr =
                        xLable
                            // insert a space before all caps
                            .replace(/([A-Z])/g, ' $1')
                            // uppercase the first character
                            .replace(/^./, function (str) { return str.toUpperCase(); });
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[5],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            bar: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointWidth: 25,
                events: {
                    click: function (event) {
                        var highResult = highData.find((row => row[0] === event.point.name));
                        var medResult = mediumData.find((row => row[0] === event.point.name));
                        var lowResult = lowData.find((row => row[0] === event.point.name));
                        var otherResult = otherData.find((row => row[0] === event.point.name));

                        var finalResult = {
                            "status": event.point.name,
                            "highTotal": highResult != null ? highResult[1] : null,
                            "medTotal": medResult != null ? medResult[1] : null,
                            "lowTotal": lowResult != null ? lowResult[1] : null,
                            "otherTotal": otherResult != null ? otherResult[1] : null
                        }
                        AlertClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: [{
            name: params[1],
            data: highData,
            color: '#e3032a'
        },
        {
            name: params[2],
            data: mediumData,
            color: '#f66a01',
        },
        {
            name: params[3],
            data: lowData,
            color: '#EDD043'
        },
        {
            name: params[4],
            data: otherData,
            color: '#ffffff'
        }]
    });
}

function fetchAlertAccuracyStatusDetailData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var highData = [];
    var mediumData = [];
    var lowData = [];
    var otherData = [];


    for (let [key, value] of map1.entries()) {
        var highTotalCount = null;
        var mediumTotalCount = null;
        var lowTotalCount = null;
        var otherTotalCount = null;

        value.forEach(function (currentValue, index, arr) {
            if (currentValue.alertSeverity != null && currentValue.alertSeverity.length > 0) {
                if (currentValue.alertSeverity.match("High")) {
                    highTotalCount = highTotalCount + currentValue.alertCount;
                }

                else if (currentValue.alertSeverity.match("Medium")) {
                    mediumTotalCount = mediumTotalCount + currentValue.alertCount;
                }

                else if (currentValue.alertSeverity.match("Low")) {
                    lowTotalCount = lowTotalCount + currentValue.alertCount;
                }
            }
            else {
                otherTotalCount = otherTotalCount + currentValue.alertCount;
            }
        });

        highData.push([key, highTotalCount]);
        mediumData.push([key, mediumTotalCount]);
        lowData.push([key, lowTotalCount]);
        otherData.push([key, otherTotalCount]);
    }


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            title: {
                text: null
            },
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var xLable = this.value;
                    if (this.value.startsWith("DUT")) {
                        xLable = this.value.substring(3);
                    }
                    var newStr =
                        xLable
                            // insert a space before all caps
                            .replace(/([A-Z])/g, ' $1')
                            // uppercase the first character
                            .replace(/^./, function (str) { return str.toUpperCase(); });
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[5],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            bar: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointWidth: 25,
                events: {
                    click: function (event) {
                        var highResult = highData.find((row => row[0] === event.point.name));
                        var medResult = mediumData.find((row => row[0] === event.point.name));
                        var lowResult = lowData.find((row => row[0] === event.point.name));
                        var otherResult = otherData.find((row => row[0] === event.point.name));

                        var finalResult = {
                            "status": event.point.name,
                            "highTotal": highResult != null ? highResult[1] : null,
                            "medTotal": medResult != null ? medResult[1] : null,
                            "lowTotal": lowResult != null ? lowResult[1] : null,
                            "otherTotal": otherResult != null ? otherResult[1] : null
                        }
                        AlertClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: [
            {
                name: params[4],
                data: otherData,
                color: '#ffffff'
            },
            {
                name:params[3],
                data: lowData,
                color: '#EDD043'
            },
            {
                name:params[2],
                data: mediumData,
                color: '#f66a01',
            },
            {
                name: params[1],
                data: highData,
                color: '#e3032a'
            }
        ]
    });
}

function fetchPreferedAlertAccuracyStatusDetailData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var highData = [];
    var mediumData = [];
    var lowData = [];
    var otherData = [];


    for (let [key, value] of map1.entries()) {
        highData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("High");
        }).length]);

        mediumData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("Medium");
        }).length]);

        lowData.push([key, value.filter(function (mData) {
            return mData.alertSeverity != null && mData.alertSeverity.length > 0 && mData.alertSeverity.match("Low");
        }).length]);

        otherData.push([key, value.filter(function (mData) {
            return mData.alertSeverity == null || mData.alertSeverity.length == 0;
        }).length]);
    }


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            title: {
                text: null
            },
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var xLable = this.value;
                    if (this.value.startsWith("DUT")) {
                        xLable = this.value.substring(3);
                    }
                    var newStr =
                        xLable
                            // insert a space before all caps
                            .replace(/([A-Z])/g, ' $1')
                            // uppercase the first character
                            .replace(/^./, function (str) { return str.toUpperCase(); });
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text:params[5]
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            bar: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointWidth: 25,
                events: {
                    click: function (event) {
                        var highResult = highData.find((row => row[0] === event.point.name));
                        var medResult = mediumData.find((row => row[0] === event.point.name));
                        var lowResult = lowData.find((row => row[0] === event.point.name));
                        var otherResult = otherData.find((row => row[0] === event.point.name));

                        var finalResult = {
                            "status": event.point.name,
                            "highTotal": highResult != null ? highResult[1] : null,
                            "medTotal": medResult != null ? medResult[1] : null,
                            "lowTotal": lowResult != null ? lowResult[1] : null,
                            "otherTotal": otherResult != null ? otherResult[1] : null
                        }
                        AlertClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: [
            {
                name: params[4],
                data: otherData,
                color: '#ffffff'
            },
            {
                name:params[3],
                data: lowData,
                color: '#EDD043'
            },
            {
                name:params[2],
                data: mediumData,
                color: '#f66a01',
            },
            {
                name: params[1],
                data: highData,
                color: '#e3032a'
            }
        ]
    });
}

function fetchDailyCpkDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var cpkData = [];
    params[0].data.forEach(function (value) {
        cpkData.push({ x: new Date(value.latestTimeStamp).getTime(), y: Number(value.cpk), dateStr: value.latestTimeStamp });
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: 0,
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text:  params[3],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var cpkDataResult = '';
                            cpkDataResult = cpkData.find(row => (row.x === this.x));
                            var result = { "date": this.dateStr, "cpkValue": cpkDataResult.y };
                            AlertClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            data: cpkData,
            color: '#f4d745'
        }]
    });
}

function fetchAlertReviewChangeLimitData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var limitChangeData = [];
    var seriesData = [];
    var index = 0;

    params[0].data.forEach(function (value) {
        if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else {
            failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }

        // if (value.lowerLimit != null && value.lowerLimit.length > 0) {
        //     lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
        // }

        // if (value.upperLimit != null && value.upperLimit.length > 0) {
        //     upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
        // }


        if (value.upperLimit != null && value.upperLimit.length > 0) {
            upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
            if (index == 0) {
                if (index + 1 < params[0].data.length) {
                    if ((value.upperLimit != params[0].data[index + 1].upperLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, });
                        }
                    }
                }
            }
            if (index == 1) {
                if (index + 1 < params[0].data.length) {
                    if (!(value.upperLimit.match(params[0].data[index + 1].upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, });
                        }
                    } else if (!(params[0].data[index - 1].upperLimit.match(value.upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    }
                }
            }

            if (index + 2 < params[0].data.length && index - 2 >= 0) {      //DQMChannel.postMessage(index);
                if ((!(value.upperLimit.match(params[0].data[index - 1].upperLimit))) || (!(value.upperLimit.match(params[0].data[index + 1].upperLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    limitChangeData.push({ x: new Date(params[0].data[index - 2].timestamp).getTime(), y: Number(params[0].data[index - 2].upperLimit), "dataObj": params[0].data[index - 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index + 2].timestamp).getTime(), y: Number(params[0].data[index + 2].upperLimit), "dataObj": params[0].data[index + 2] });
                } else if ((!(params[0].data[index - 2].upperLimit.match(params[0].data[index - 1].upperLimit))) || (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
                }
            }
            if (index == params[0].data.length - 1) {
                if (index - 1 > params[0].data.length) {
                    if ((value.upperLimit != params[0].data[index - 1].upperLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index - 2 > params[0].data.length) {
                        if (!(params[0].data[index - 1].upperLimit.match(params[0].data[index - 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, });
                        }
                    }
                }
            }
            if (index == params[0].data.length - 2) {
                if (index - 2 < params[0].data.length) {
                    if (!(value.upperLimit.match(params[0].data[index - 1].upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index - 2 < params[0].data.length) {
                        if (!(params[0].data[index - 1].upperLimit.match(params[0].data[index - 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, });
                        }
                    } else if (!(params[0].data[index - 1].upperLimit.match(value.upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    }
                }
            }
        }
        if (value.lowerLimit != null && value.lowerLimit.length > 0) {
            lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
            if (index == 0) {
                if (index + 1 < params[0].data.length) {
                    if ((value.lowerLimit != params[0].data[index + 1].lowerLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, });
                        }
                    }
                }
            }
            if (index == 1) {
                if (index + 1 < params[0].data.length) {
                    if (!(value.lowerLimit.match(params[0].data[index + 1].lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, });
                        }
                    } else if (!(params[0].data[index - 1].lowerLimit.match(value.lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    }
                }
            }

            if (index + 2 < params[0].data.length && index - 2 >= 0) {
                if ((!(value.lowerLimit.match(params[0].data[index - 1].lowerLimit))) || (!(value.lowerLimit.match(params[0].data[index + 1].lowerLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    limitChangeData.push({ x: new Date(params[0].data[index - 2].timestamp).getTime(), y: Number(params[0].data[index - 2].lowerLimit), "dataObj": params[0].data[index - 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index + 2].timestamp).getTime(), y: Number(params[0].data[index + 2].lowerLimit), "dataObj": params[0].data[index + 2] });
                } else if ((!(params[0].data[index - 2].lowerLimit.match(params[0].data[index - 1].lowerLimit))) || (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
                }
            }
            if (index == params[0].data.length - 1) {
                if (index - 1 > params[0].data.length) {
                    if ((value.lowerLimit != params[0].data[index - 1].lowerLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index - 2 > params[0].data.length) {
                        if (!(params[0].data[index - 1].lowerLimit.match(params[0].data[index - 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, });
                        }
                    }
                }
            }
            if (index == params[0].data.length - 2) {
                if (index - 2 < params[0].data.length) {
                    if (!(value.lowerLimit.match(params[0].data[index - 1].lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    } else if (index - 2 < params[0].data.length) {
                        if (!(params[0].data[index - 1].lowerLimit.match(params[0].data[index - 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, });
                        }
                    } else if (!(params[0].data[index - 1].lowerLimit.match(value.lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    }
                }
            }
        }
        index++;
    });

    seriesData.push({ name: params[1], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[2], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[3], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[6], data: lowerLimitData, color: '#000000', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[7], data: upperLimitData, color: '#000000', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: limitChangeData, color: 'rgb(245,215,69)', marker: { radius: 2, symbol: 'circle' } });

    Highcharts.chart('container', {
        chart: {
            type: 'scatter',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
            events: {
                load() {
                    this.series[0].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[1].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[2].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[3].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[4].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[5].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[6].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    })
                }
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: "datetime",
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 2);
                }
            }
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[8],
        },
        legend: {
            enabled: true,
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            series: { turboThreshold: 0 },
            scatter: {
                marker: {
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                },
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                point: {
                    events: {
                        click: function (event) {
                            AlertClickChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function prefixConversion(...params) {
    // Checking is a string
    let numbers = typeof params[0] === 'string' ? parseFloat(params[0]) : params[0];

    let isNegative = false;
    if (numbers < 0) {
        isNegative = true;
        numbers = numbers * -1;
    }

    if (numbers > 1) {
        return convertPositiveE(numbers, params[1], isNegative);
    } else {
        return convertNegativeE(numbers, params[1], isNegative);
    }
}

function convertNegativeE(...params) {
    const prefix = ['', 'm', 'µ', 'n', 'p', 'f', 'a', 'z', 'y'];
    let ii = 0;
    const k = params[1] === undefined ? 1 : params[1];
    let convertNumber = 0;

    let currentPow = 1;
    let overflow = true;

    for (let i = 0; i <= 8; i++) {
        const numberPow = params[0] * Math.pow(10, currentPow * 3);
        if (numberPow >= 1000) {
            convertNumber = numberPow;
            ii = i;
            overflow = false;
            break;
        }
        currentPow++;
    }

    if (overflow) {
        return convertToExponential(params[0], k, params[2]);
    } else {
        let value;
        if (params[2]) {
            value = (-convertNumber / 1000).toFixed(k);
        } else {
            value = (convertNumber / 1000).toFixed(k);
        }

        return value + prefix[ii];
    }
}

function convertPositiveE(...params) {
    const prefix = ['', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'];
    let ii = 0;
    const k = params[1] === undefined ? 1 : params[1];
    let convertNumber = 0;

    let currentPow = 1;
    let overflow = true;
    for (let i = 0; i <= 8; i++) {
        const numberPow = params[0] / Math.pow(10, currentPow * 3);
        if (numberPow < 1) {
            convertNumber = numberPow;
            ii = i;
            overflow = false;
            break;
        }
        currentPow++;
    }

    if (overflow) {
        return convertToExponential(params[0], k, params[2]);
    } else {
        let value;
        if (params[2]) {
            value = (-convertNumber * 1000).toFixed(k);
        } else {
            value = (convertNumber * 1000).toFixed(k);
        }

        return value + prefix[ii];
    }
}

function convertToExponential(...params) {
    const convertNumber = params[0] / 1;
    if (convertNumber === 0) {
        return 0;
    } else if (params[2]) {
        return -convertNumber.toExponential(params[1]);
    } else {
        return convertNumber.toExponential(params[1]);
    }
}




function probeFinder(...params) {
    var seriesData = [];


    var fixtureMaps = params[0];
    var fixtureMapsAnomaly = params[1];
    var fixtureOutlineDTOs = params[2];
    var testName = params[3];
    var fixtureLayout = params[4];

    var ratio = fixtureOutlineDTOs[0]['ratio'];
    var ratioBased = ratio.split(":");
    var xRatio = ratioBased[0];
    var yRatio = ratioBased[1];
    var OutlineData = [];
    var DotMapData = [];
    var dotAnnomaly = [];
    var dotSelected = [];
    var LayoutDotData = [];
    var gheight = 100;

    if (yRatio < 1 || xRatio < 1) {
        if (yRatio < 1) {
            gheight = ((yRatio / xRatio) * 100).toFixed(0);
        }
        else {
            gheight = ((xRatio / yRatio) * 100).toFixed(0);
        }
    }
    // AlertProdeFinderChannel.postMessage('here');
    // AlertProdeFinderChannel.postMessage(testName);
    // AlertProdeFinderChannel.postMessage('correct');

    fixtureLayout.forEach(function (value) {
        LayoutDotData.push({ x: Number(value.x), y: Number(value.y), "dataObj": value });
    });

    fixtureOutlineDTOs[0]['xy'].forEach(function (value) {
        OutlineData.push({ x: parseInt(value[0]), y: parseInt(value[1]) });
    });

    fixtureMaps.forEach(function (value) {

        DotMapData.push({ x: Number(value.x), y: Number(value.y), "dataObj": value });

    });


    //  AlertProdeFinderChannel.postMessage(OutlineData[150]);
    fixtureMapsAnomaly.forEach(function (value) {
        if (value.testNames.includes(testName)) {
            // AlertProdeFinderChannel.postMessage('correct');
            dotSelected.push({ x: Number(value.x), y: Number(value.y), "dataObj": value });
        }

        dotAnnomaly.push({ x: Number(value.x), y: Number(value.y), "dataObj": value });
    });

    seriesData.push(
        {

            name: "OutLine",
            data: OutlineData,
            color: 'rgba(115, 211, 44, 0.9)',
            lineWidth: 2,
            marker: { radius: 0, enabled: false },
            showInLegend: false,
            enableMouseTracking: false
        });
    seriesData.push(
        {

            name: "ProbeLayout",
            data: LayoutDotData,
            color: 'rgba(56, 183, 247,0.05)',
            marker: { radius: 2, symbol: 'circle' },
            showInLegend: false,
            enableMouseTracking: false
        });
    seriesData.push(
        {
            states: {
                inactive: {
                    opacity: 1
                }
            },
            name: params[5],
            data: DotMapData,
            marker: { radius: 2, symbol: 'circle' },
            color: 'rgb(56, 183, 247)',

            // color: 'rgb(254, 222, 0)',  
        });
    seriesData.push(
        {
            name: params[6],
            data: dotAnnomaly,
            marker: { radius: 2, symbol: 'circle' },
            //  color: 'rgb(56, 183, 247)',  
            color: 'rgb(254, 222, 0)',
        });
    seriesData.push(
        {
            name: params[7],
            data: dotSelected,
            marker: { radius: 2, symbol: 'circle' },
            color: 'rgb(255, 20, 20)',
        });

    chart1 = Highcharts.chart('container', {
        animation: false,
        chart: {
            type: 'scatter',
            height: (gheight + '%'),
            spacingTop: 0,
            marginLeft: 0,
            marginBottom: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
            events: {
                load() {


                    this.series[2].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[3].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[4].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                }
            }
        },
        xAxis: {
            gridLineColor: 'transparent',
            lineColor: 'transparent',
            minorGridLineColor: 'transparent',
            tickColor: 'transparent',

        },
        yAxis: {
            gridLineColor: 'transparent',
            lineColor: 'transparent',
            minorGridLineColor: 'transparent',
            tickColor: 'transparent',
        },
        credits: {
            enabled: false,
            position: {
                align: 'center',
                x: 0
            },
            text: 'Probe Finder',
        },
        legend: {
            enabled: true,
            // x: -10,
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {

            scatter: {

                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {

                }

            },
            series: {

                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {

                            AlertProdeFinderChannel.postMessage(JSON.stringify(event.point.dataObj));
                            // cpkDataResult = cpkData.find(row => (row.x === this.x));
                            // var result = { "date": this.dateStr, "cpkValue": cpkDataResult.y };
                            // AlertClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });


}

function fetchRmaScatterData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var seriesData = [];

    params[0].data.forEach(function (value) {
        // AlertTestResultChannel.postMessage(value);
        if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                // AlertTestResultChannel.postMessage(value.measured);

                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });


            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {


                passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });

            }
        }
        else if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {

            falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });


        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {

            anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });

        }
        else {

            failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });

        }

        if (value.lowerLimit != null && value.lowerLimit.length > 0) {
            lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
        }

        if (value.upperLimit != null && value.upperLimit.length > 0) {
            upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
        }

    });

    seriesData.push({ name: params[3], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[8], data: lowerLimitData, color: '#000000', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[9], data: upperLimitData, color: '#000000', marker: { radius: 2, symbol: 'circle' } });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'scatter',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
            events: {
                load() {
                    this.series[0].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[1].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[2].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[3].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[4].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });

                    this.series[5].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    })
                }
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: "datetime",
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(0, 0, 0, 1)',
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text:  params[2],
        },
        legend: {
            enabled: true,
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            scatter: {
                marker: {
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                },
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                point: {

                }
            },
            series: {
                events: {
                    click: function (event) {
                        AlertTestResultChannel.postMessage(JSON.stringify(event.point.dataObj));
                    }
                }
            }
        },
        series: seriesData,
    });
}



/**function getPointCategoryName(point, dimension) {
    var series = point.series,
        isY = dimension === 'y',
        axis = series[isY ? 'yAxis' : 'xAxis'];
    return axis.categories[point[isY ? 'y' : 'x']];
}

Highcharts.chart('container', {

    chart: {
        type: 'heatmap',
        
        marginRight: 0,
        marginLeft: 0,
        marginBottom: 0,
       
    },


    title: {
        text: 'Sales per employee per weekday'
    },

    xAxis: {
        categories: ['Alexander', 'Marie', 'Maximilian', 'Sophia', 'Lukas', 'Maria', 'Leon', 'Anna', 'Tim', 'Laura']
    },

    yAxis: {
        categories: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        title: null,
        reversed: true
    },

    accessibility: {
        point: {
            descriptionFormatter: function (point) {
                var ix = point.index + 1,
                    xName = getPointCategoryName(point, 'x'),
                    yName = getPointCategoryName(point, 'y'),
                    val = point.value;
                return ix + '. ' + xName + ' sales ' + yName + ', ' + val + '.';
            }
        }
    },

    colorAxis: {
        min: 0,
        
        stops: [
            [0, 'rgb(0,0,239)'],
            [0.125,'rgb(0,143,255)'],
            [0.25,'rgb(0, 239,255)'],
            [0.375,'rgb(63,255,191)'],
            [0.5, 'rgb(175, 255,79)'],
                    [0.625, 'rgb(255, 255,0)'],
            [0.75, 'rgb(255, 159,0)'],
            [0.875,  'rgb(255, 0,0)'],
            [1,  'rgb(205, 0,0)'],
        ],
      
        max: 150,
        
    },

    legend: {
    
        layout: 'horizontal',
     marginTop: 200,
        verticalAlign: 'top',
    
        symbolHeight: 10
    },

    tooltip: {
        formatter: function () {
            return '<b>' + getPointCategoryName(this.point, 'x') + '</b> sold <br><b>' +
                this.point.value + '</b> items on <br><b>' + getPointCategoryName(this.point, 'y') + '</b>';
        }
    },

    series: [{
        name: 'Sales per employee',
      
        data: [ [02, 1, 19], [0, 2, 8], [0, 3, 24], [0, 4, 67], [1, 0, 92], [1, 1, 58], [1, 2, 78], [1, 3, 117], [1, 4, 48], [2, 0, 35], [2, 1, 15], [2, 2, 123], [2, 3, 64], [2, 4, 52], [3, 0, 72], [3, 1, 132], [3, 2, 114], [3, 3, 19], [3, 4, 16], [4, 0, 38], [4, 1, 5], [4, 2, 8], [4, 3, 117], [4, 4, 115], [5, 0, 88], [5, 1, 32], [5, 2, 12], [5, 3, 6], [5, 4, 120], [6, 0, 13], [6, 1, 44], [6, 2, 88], [6, 3, 98], [6, 4, 96], [7, 0, 31], [7, 1, 1], [7, 2, 82], [7, 3, 32], [7, 4, 30], [8, 0, 85], [8, 1, 97], [8, 2, 123], [8, 3, 64], [8, 4, 84], [9, 0, 47], [9, 1, 114], [9, 2, 31], [9, 3, 48], [9, 4, 91]],
         marker: { radius: 2, symbol: 'circle' },
        dataLabels: {
            enabled: true,
            color: '#000000'
        }
    }],

    responsive: {
        rules: [{
            condition: {
                maxWidth: 10
            },
            chartOptions: {
                yAxis: {
                    labels: {
                        formatter: function () {
                            return this.value.charAt(0);
                        }
                    }
                }
            }
        }]
    }

}); */