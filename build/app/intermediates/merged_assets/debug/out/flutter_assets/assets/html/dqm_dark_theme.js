$(function () {
    Highcharts.theme = {
        colors: [
            'rgb(245,215,69)',
            'rgb(251,164,10)',
            'rgb(243,119,25)',
            'rgb(220,80,57)',
            'rgb(187,55,84)',
            'rgb(147,37,103)',
            'rgb(106,23,110)',
            'rgb(81,85,155)',
            'rgb(17,95,178)',
            'rgb(7,155,191)',
            'rgb(5,160,167)',
            '#72F5D4',
            '#4ECDC4',
            '#007EC7',
            '#00DAF0',
            '#B9E8E0',
            'rgb(207,240,158)',
            'rgb(180,226,165)',
            'rgb(127,193,156)',
            'rgb(57,131,133)',
            'rgb(34,102,120)',
            'rgb(11,72,107)',
            '#6C4F70',
            '#00B7A8',
            '#ACA8FF',
            '#70A1D7',
            '#A1DE93',
            '#F7F48B',
            '#FDDD8A',
            '#F47C7C',
            '#5A3921',
            '#45415E',
            '#726A95',
            '#037367',
            '#6B8C42',
            '#BEA42E',
            '#7BC67B',
            '#7BD4CC',
            '#096386',
            '#709FB0',
            '#085F63',
            '#49BEB7',
            '#ECC7C0',
            '#FDAE84',
            '#FABC60',
            '#FFFFB5',
            '#FACF5A',
            '#ED553B',
            '#F6D55C',
            '#F0EEC8',
            '#E7CC8F',
            '#EFAA52',
            '#F77754',
            '#E16262',
            '#D73A31',
            '#20639B',
            '#36384C',
            '#3CAEA3',
            '#849974',
            '#A0C1B8',
            '#AB3E16',
            '#FF5959',
            '#E3BAB3',
            '#F4E8C1',
            '#FFFFFF',
            '#F44336',
            '#E91E63',
            '#9C27B0',
            '#673AB7',
            '#3F51B5',
            '#2196F3',
            '#03A9F4',
            '#00BCD4',
            '#009688',
            '#4CAF50',
            '#8BC34A',
            '#CDDC39',
            '#ffe821',
            '#FFC107',
            '#FF9800',
            '#FF5722',
            '#45451E',
            '#08708A',
            '#A2738C',
            '#6B82A8',
            '#56B1BF',
            '#5B7D87',
            '#91B3BC',
            '#D1D3CF',
            '#8BCBC8',
            '#D0D3C5',
            '#039BD5',
            '#A4C63A',
            '#FEDE00',
            '#F8991C',
            '#EF487D',
            '#FF7360',
            '#6FC8CE',
            '#FAFFF2',
            '#FFFCC4',
            '#B9E8E0',
            '#F2DFBE',
            '#FFC189',
            '#F5AB99',
            '#F07A9A',
            '#FF7E5F',
            '#FEB47B',
            '#FFE66D',
            '#04A777',
            '#4ECDC4',
            '#6CBF84',
            '#FF6BBB',
            '#FF6B6B',
            '#D90368',
            '#F4E8C1',
            '#DFE2D2',
            '#F0F7EE',
            '#83B692',
            '#009BFC',
            '#ED6A5A',
            '#F0A61F',
            '#FF8A12',
            '#337873',
            '#2b908f',
            '#90ee7e',
            '#f45b5b',
            '#7798BF',
            '#aaeeee',
            '#ff0066',
            '#eeaaee',
            '#55BF3B',
            '#DF5353',
            '#7798BF',
            '#aaeeee',
            '#085B6D',
            '#345477',
            '#FFB8BA',
            '#FF9194',
            '#FF4C8E',
            '#FF2E45',
            '#faff00',
            '#00ffff',
            '#ff00e5',
            '#00d539',
            '#ff005c',
            '#3385ff',
            '#ff9000',
            '#ad6aff',
            '#ffa8a7',
            '#779100',
            '#00b287',
            '#00b8dd',
            'RGB(184, 186, 191)',
            'RGB(145, 148, 153)',
            'RGB(76, 142, 255)',
            'RGB(46, 69, 133)',
            'RGB(229, 238, 255)'
        ],
        chart: {
            backgroundColor: 'rgba(0, 0, 0, 0.0)',
            style: {
                fontFamily: '\'Roboto\', sans-serif'
            },
            plotBorderColor: '#292b2c',
            reflow: true,
            panning: {
                enabled: true,
                type: 'xy'
            },
            selectionMarkerFill: 'rgba(255, 255, 255, 0.3)',
            resetZoomButton: {
                position: { x: 0, y: 1 },
                theme: {
                    fill: 'rgba(60,61,68, 0.2)',
                    stroke: '#4c8eff',
                    style: { color: 'white' },
                    states: { hover: { fill: 'rgb(60,61,60)', style: { color: 'white' } } }
                }
            }
        },
        title: {
            style: {
                color: '#E0E0E3',
                textTransform: 'uppercase',
                fontSize: '14px'
            },
            text: undefined
        },
        subtitle: {
            style: {
                color: '#E0E0E3',
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
                    color: '#B1B1B1'
                },
            },
            title: {
                text: undefined,
                style: {
                    color: '#A0A0A3'
                },
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: '#B1B1B1'
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
                color: '#B1B1B1',
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
                    color: '#B1B1B1',
                    fontSize: '13'
                }
            }
        },
        credits: {
            style: {
                color: 'rgba(177, 177, 177, 0.4)',
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
        exporting: {
            enabled: false
        }
    };
    // Apply the theme
    Highcharts.setOptions(Highcharts.theme);
    DQMChannel.postMessage("");
});

function fetchDailyVolumeData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var faileData = [];
    var passData = [];
    var reworkData = [];

    params[0].map(function (row) {
        faileData.push([new Date(row.date).getTime(), row.failed]);
        passData.push([new Date(row.date).getTime(), row.firstPass]);
        reworkData.push([new Date(row.date).getTime(), row.rework]);
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMDailyVolumeChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMDailyVolumeChannel.postMessage('');
                    }
                }
            },
        },
        series: [{
            name: params[3],
            data: faileData,
            color: '#e3032a'
        },
        {
            name: params[4],
            data: reworkData,
            color: '#f66a01',
        },
        {
            name: params[5],
            data: passData,
            color: '#73d329'
        }]
    });
}


var chart1 = null;
var chart2 = null;
var chart3 = null;
var chart4 = null;
function fetchDailyVolumeDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var passData = [];
    var reworkData = [];

    params[0].data.map(function (row) {
        failedData.push({ x: new Date(row.date).getTime(), y: row.failed, dateStr: row.date });
        passData.push({ x: new Date(row.date).getTime(), y: row.firstPass, dateStr: row.date });
        reworkData.push({ x: new Date(row.date).getTime(), y: row.rework, dateStr: row.date });
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[6],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                point: {
                    events: {
                        click: function (event) {
                            var passDataResult = '';
                            var retestDataResult = '';
                            var failDataResult = '';
                            failDataResult = failedData.find(row => (row.x === this.x));
                            passDataResult = passData.find(row => (row.x === this.x));
                            retestDataResult = reworkData.find(row => (row.x === this.x));
                            var result = { "date": this.dateStr, "failed": failDataResult.y, "firstPass": passDataResult.y, "rework": retestDataResult.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: params[3],
            data: failedData,
            color: '#e3032a'
        },
        {
            name: params[4],
            data: reworkData,
            color: '#f66a01',
        },
        {
            name: params[5],
            data: passData,
            color: '#73d329'
        }]
    });
}

function fetchDailyFirstPassYieldData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var firstPassData = [];
    var minValue = null;
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                const dValue = ((value.firstPass) / (value.firstPass + value.rework + value.failed)) * 100;
                if (minValue == null) {
                    minValue = dValue;
                }
                else {
                    if (minValue > dValue) {
                        minValue = dValue;
                    }
                }
                firstPassData.push([new Date(value.date).getTime(), dValue]);
            }
        });

        if (!isValid) {
            firstPassData.push([new Date(currentValue).getTime(), null]);
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMDailyFirstPassChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            series: {
                marker: {
                    enabled: false,
                    radius: 3,
                    states: {
                        hover: {
                            enabled: false
                        }
                    }
                },
            },
            line: {
                events: {
                    click: function (event) {
                        DQMDailyFirstPassChannel.postMessage('');
                    }
                }
            },
        },
        series: [{
            name: "First Pass",
            data: firstPassData,
            color: 'rgb(115, 211, 44)'
        }]
    });
}

function fetchFirstPassYieldDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var firstPassData = [];
    var minValue = null;
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                const dValue = ((value.firstPass) / (value.firstPass + value.rework + value.failed)) * 100;
                if (minValue == null) {
                    minValue = dValue;
                }
                else {
                    if (minValue > dValue) {
                        minValue = dValue;
                    }
                }
                firstPassData.push({ x: new Date(value.date).getTime(), y: ((value.firstPass) / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, dateStr: currentValue });
        }
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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[4],
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var firstPassDataResult = '';
                            firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var result = { "date": this.dateStr, "firstPassYield": firstPassDataResult.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "First Pass",
            data: firstPassData,
            color: 'rgb(115, 211, 44)'
        }]
    });
}

function fetchFirstPassFinalYieldDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var finalYieldData = [];
    var minValue = null;
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                const dValue = ((value.firstPass + value.rework) / (value.firstPass + value.rework + value.failed)) * 100;
                finalYieldData.push({ x: new Date(value.date).getTime(), y: dValue, dateStr: value.date });
                if (minValue == null) {
                    minValue = dValue;
                }
                else {
                    if (minValue > dValue) {
                        minValue = dValue;
                    }
                }
            }
        });

        if (!isValid) {
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, dateStr: currentValue });
        }
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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[4],
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
                            var finalYieldDataResult = '';
                            finalYieldDataResult = finalYieldData.find(row => (row.x === this.x));
                            var result = { "date": this.dateStr, "firstPassYield": finalYieldDataResult.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Final Yield",
            data: finalYieldData,
            color: 'rgb(115, 211, 44)'
        }]
    });
}

function fetchYieldProjectData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    const map1 = new Map(Object.entries(params[4]));
    var seriesData = [];
    var minValue = null;
    for (let [key, value] of map1.entries()) {
        var firstPassData = [];
        params[3].forEach(function (currentValue, index, arr) {
            var isValid = false;
            value.forEach(function (mData) {
                if (new Date(currentValue).getTime() == new Date(mData.date).getTime()) {
                    isValid = true;
                    let num = (mData.firstPass / (mData.firstPass + mData.rework + mData.failed)) * 100;
                    firstPassData.push([new Date(mData.date).getTime(), parseFloat(num.toFixed(2))]);
                    if (minValue == null) {
                        minValue = num;
                    }
                    else {
                        if (minValue > num) {
                            minValue = num;
                        }
                    }
                }
            });

            if (!isValid) {
                firstPassData.push([new Date(currentValue).getTime(), null]);
            }
        });

        seriesData.push({ "name": key, "data": firstPassData });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMFirstPassYieldByProjectChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            series: {
                marker: {
                    enabled: false,
                    radius: 3,
                    states: {
                        hover: {
                            enabled: false
                        }
                    }
                },
            },
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    click: function (event) {
                        DQMFirstPassYieldByProjectChannel.postMessage('');
                    }
                }
            },
        },
        series: seriesData
    });
}

function fetchFirstPassYieldByProjectDetailData(...params) {
    var colors = ['#F5D745', '#FBA40A', '#F37719', '#DC5039', '#BB3754', '#932567', '#6A176E', '#51559B', '#115FB2', '#079BBF', '#05A0A7', '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0',];
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    const map1 = new Map(Object.entries(params[4]));
    var seriesData = [];
    var dataResult = [];
    var index = 0;
    var minValue = null;
    for (let [key, value] of map1.entries()) {
        if (params[5].some(e => e.projectId === key && e.isSelected)) {
            var firstPassYieldData = [];
            params[3].forEach(function (currentValue, index, arr) {
                var isValid = false;
                value.forEach(function (mData) {
                    if (new Date(currentValue).getTime() == new Date(mData.date).getTime()) {
                        isValid = true;
                        let num = (mData.firstPass / (mData.firstPass + mData.rework + mData.failed)) * 100;
                        firstPassYieldData.push({ x: new Date(mData.date).getTime(), y: parseFloat(num.toFixed(2)), dateStr: mData.date, projectName: mData.projectId });
                        if (minValue == null) {
                            minValue = num;
                        }
                        else {
                            if (minValue > num) {
                                minValue = num;
                            }
                        }
                    }
                });

                if (!isValid) {
                    firstPassYieldData.push({ x: new Date(currentValue).getTime(), y: null, dateStr: currentValue });
                }
            });
            dataResult.push(firstPassYieldData);
            seriesData.push({ "name": key, "data": firstPassYieldData, "color": colors[index] });
        }

        index++;
    }

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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[6],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            line: {
                marker: {
                    symbol: 'circle'
                }
            },
            series: {
                cursor: 'pointer',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                point: {
                    events: {
                        click: function (event) {
                            var result = [];
                            dataResult.forEach(function (sData, index) {
                                var findedData = sData.find(row => (row.x === event.point.x));
                                if (findedData.projectName != null) {
                                    result.push({ "yieldValue": findedData.y, "projectName": findedData.projectName, "colorCode": seriesData[index].color })
                                }

                            });
                            var finalResult = { "date": this.dateStr, "data": result };
                            DQMClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData
    });
}

function fetchFinalYieldByProjectDetailData(...params) {
    var colors = ['#F5D745', '#FBA40A', '#F37719', '#DC5039', '#BB3754', '#932567', '#6A176E', '#51559B', '#115FB2', '#079BBF', '#05A0A7', '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0',];
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    const map1 = new Map(Object.entries(params[4]));
    var seriesData = [];
    var dataResult = [];
    var index = 0;
    var minValue = null;
    for (let [key, value] of map1.entries()) {
        if (params[5].some(e => e.projectId === key && e.isSelected)) {
            var finalYieldData = [];
            params[3].forEach(function (currentValue, index, arr) {
                var isValid = false;
                value.forEach(function (mData) {
                    if (new Date(currentValue).getTime() == new Date(mData.date).getTime()) {
                        isValid = true;
                        let num = ((mData.firstPass + mData.rework) / (mData.firstPass + mData.rework + mData.failed)) * 100;
                        finalYieldData.push({ x: new Date(mData.date).getTime(), y: parseFloat(num.toFixed(2)), dateStr: mData.date, projectName: mData.projectId });
                        if (minValue == null) {
                            minValue = num;
                        }
                        else {
                            if (minValue > num) {
                                minValue = num;
                            }
                        }
                    }
                });

                if (!isValid) {
                    finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, dateStr: currentValue });
                }
            });

            dataResult.push(finalYieldData);
            seriesData.push({ "name": key, "data": finalYieldData, "color": colors[index] });
        }

        index++;
    }

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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[6],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            line: {
                marker: {
                    symbol: 'circle'
                }
            },
            series: {
                cursor: 'pointer',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                point: {
                    events: {
                        click: function (event) {
                            var result = [];
                            dataResult.forEach(function (sData, index) {
                                var findedData = sData.find(row => (row.x === event.point.x));
                                if (findedData.projectName != null) {
                                    result.push({ "yieldValue": findedData.y, "projectName": findedData.projectName, "colorCode": seriesData[index].color })
                                }

                            });
                            var finalResult = { "date": this.dateStr, "data": result };
                            DQMClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData
    });
}

function fetchVolumeByProjectData(...params) {
    var faileData = [];
    var passData = [];
    var reworkData = [];

    params[0].map(function (row) {
        var newStr = '';
        if (row.projectId.includes('<')) {
            const myArray = row.projectId.split("<");
            newStr = myArray[0] + "&lt;" + myArray[1];
        }
        else {
            newStr = row.projectId;
        }
        faileData.push([newStr, row.failed]);
        passData.push([newStr, row.firstPass]);
        reworkData.push([newStr, row.rework]);
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMVolumeByProjectChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: 'category',
        },
        yAxis: {
            min: 0,
        },
        credits: {
            enabled: false
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
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMVolumeByProjectChannel.postMessage('');
                    }
                }
            },
            // series: {
            //     pointWidth: 50,
            // }
        },
        series: [{
            name: params[3],
            data: faileData,
            color: '#e3032a'
        },
        {
            name: params[4],
            data: reworkData,
            color: '#f66a01',
        },
        {
            name: params[5],
            data: passData,
            color: '#73d329'
        }]
    });
}

function fetchVolumeByProjectDetailData(...params) {
    var failedData = [];
    var passData = [];
    var reworkData = [];
    var projectNames = [];

    params[0].data.map(function (row) {
        if (params[1].some(e => e.projectId === row.projectId && e.isSelected)) {
            projectNames.push(row.projectId);
            failedData.push([row.projectId, row.failed]);
            passData.push([row.projectId, row.firstPass]);
            reworkData.push([row.projectId, row.rework]);
        }
    });

    var chartHeight = 350;
    // if (projectNames.length > 5) {
    //     chartHeight = 600;
    // }

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
            },
            events: {
                click: function (event) {
                    DQMClickChannel.postMessage(projectNames[smallValueClickFunc(event).x]);
                }
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
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var newStr = '';
                    if (this.value.includes('<')) {
                        const myArray = this.value.split("<");
                        newStr = myArray[0] + "&lt;" + myArray[1];
                    }
                    else {
                        newStr = this.value;
                    }
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            DQMClickChannel.postMessage(event.point.name);
                        }
                    }
                },
                // pointWidth: 50,
            }
        },
        series: [{
            name: params[2],
            data: failedData,
            color: '#e3032a'
        },
        {
            name: params[3],
            data: reworkData,
            color: '#f66a01',
        },
        {
            name: params[4],
            data: passData,
            color: '#73d329'
        }]
    });
}

function fetchTop5WorstTestNamesByProjectData(...params) {
    var colors = ['#F5D745', '#FBA40A', '#F37719', '#DC5039', '#BB3754', '#932567', '#6A176E', '#51559B', '#115FB2', '#079BBF', '#05A0A7', '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0'];
    const map1 = new Map(Object.entries(params[1]));
    var projectNames = [];
    var wtnpData1 = [];
    var wtnpData2 = [];
    var wtnpData3 = [];
    var wtnpData4 = [];
    var wtnpData5 = [];
    var colorIndex = 0;
    for (let [key, value] of map1.entries()) {
        var newStr = '';
        if (key.includes('<')) {
            const myArray = key.split("<");
            newStr = myArray[0] + "&lt;" + myArray[1];
        }
        else {
            newStr = key;
        }
        projectNames.push(newStr);
        value.forEach(function (mData, index) {
            if (index == 0) {
                wtnpData1.push({ y: mData.failedCount, testName: mData.testName, color: colors[colorIndex] });
            }
            else if (index == 1) {
                wtnpData2.push({ y: mData.failedCount, testName: mData.testName, color: colors[colorIndex] });
            }
            else if (index == 2) {
                wtnpData3.push({ y: mData.failedCount, testName: mData.testName, color: colors[colorIndex] });
            }
            else if (index == 3) {
                wtnpData4.push({ y: mData.failedCount, testName: mData.testName, color: colors[colorIndex] });
            }
            else if (index == 4) {
                wtnpData5.push({ y: mData.failedCount, testName: mData.testName, color: colors[colorIndex] });
            }

            colorIndex++;
        });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMWTNPByProjectChannel.postMessage('');
                }
            }
        },
        xAxis: {
            categories: projectNames,
        },
        yAxis: {
            min: 0,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
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
                events: {
                    click: function (event) {
                        DQMWTNPByProjectChannel.postMessage('');
                    }
                }
            },
            series: {
                pointWidth: 50,
            }
        },
        series: [
            {
                data: wtnpData1
            },
            {
                data: wtnpData2
            },
            {
                data: wtnpData3
            },
            {
                data: wtnpData4
            },
            {
                data: wtnpData5
            }
        ],
    });
}

function fetchTop5WorstTestNamesByProjectDetailData(...params) {
    var colors = ['#F5D745', '#FBA40A', '#F37719', '#DC5039', '#BB3754', '#932567', '#6A176E', '#51559B', '#115FB2', '#079BBF', '#05A0A7', '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0'];
    const map1 = new Map(Object.entries(params[1]));
    var projectIdList = [];
    var projectNames = [];
    var wtnpData1 = [];
    var wtnpData2 = [];
    var wtnpData3 = [];
    var wtnpData4 = [];
    var wtnpData5 = [];
    var colorIndex = 0;
    for (let [key, value] of map1.entries()) {
        if (params[2].some(e => e.projectId === key && e.isSelected)) {
            var newStr = '';
            if (key.includes('<')) {
                const myArray = key.split("<");
                newStr = myArray[0] + "&lt;" + myArray[1];
            }
            else {
                newStr = key;
            }
            projectIdList.push(key);
            projectNames.push(newStr);
            value.forEach(function (mData, index) {
                if (index == 0) {
                    wtnpData1.push({ y: mData.failedCount, testName: mData.testName, testType: mData.testType, projectId: mData.projectId, color: colors[colorIndex] });
                }
                else if (index == 1) {
                    wtnpData2.push({ y: mData.failedCount, testName: mData.testName, testType: mData.testType, projectId: mData.projectId, color: colors[colorIndex] });
                }
                else if (index == 2) {
                    wtnpData3.push({ y: mData.failedCount, testName: mData.testName, testType: mData.testType, projectId: mData.projectId, color: colors[colorIndex] });
                }
                else if (index == 3) {
                    wtnpData4.push({ y: mData.failedCount, testName: mData.testName, testType: mData.testType, projectId: mData.projectId, color: colors[colorIndex] });
                }
                else if (index == 4) {
                    wtnpData5.push({ y: mData.failedCount, testName: mData.testName, testType: mData.testType, projectId: mData.projectId, color: colors[colorIndex] });
                }

                colorIndex++;
            });
        }
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
            events: {
                click: function (event) {
                    var wtnpDataResult1 = '';
                    var wtnpDataResult2 = '';
                    var wtnpDataResult3 = '';
                    var wtnpDataResult4 = '';
                    var wtnpDataResult5 = '';
                    var findedData = [];
                    var cat = projectIdList[smallValueClickFunc(event).x];

                    wtnpDataResult1 = wtnpData1.find(row => (row.projectId === cat));
                    wtnpDataResult2 = wtnpData2.find(row => (row.projectId === cat));
                    wtnpDataResult3 = wtnpData3.find(row => (row.projectId === cat));
                    wtnpDataResult4 = wtnpData4.find(row => (row.projectId === cat));
                    wtnpDataResult5 = wtnpData5.find(row => (row.projectId === cat));
                    if (wtnpDataResult1 != null) {
                        findedData.push({ "testname": wtnpDataResult1.testName, "failedCount": wtnpDataResult1.y, "colorCode": wtnpDataResult1.color, 'testtype': wtnpDataResult1.testType, 'projectId': wtnpDataResult1.projectId });
                    }
                    if (wtnpDataResult2 != null) {
                        findedData.push({ "testname": wtnpDataResult2.testName, "failedCount": wtnpDataResult2.y, "colorCode": wtnpDataResult2.color, 'testtype': wtnpDataResult2.testType, 'projectId': wtnpDataResult2.projectId });
                    }
                    if (wtnpDataResult3 != null) {
                        findedData.push({ "testname": wtnpDataResult3.testName, "failedCount": wtnpDataResult3.y, "colorCode": wtnpDataResult3.color, 'testtype': wtnpDataResult3.testType, 'projectId': wtnpDataResult3.projectId });
                    }
                    if (wtnpDataResult4 != null) {
                        findedData.push({ "testname": wtnpDataResult4.testName, "failedCount": wtnpDataResult4.y, "colorCode": wtnpDataResult4.color, 'testtype': wtnpDataResult4.testType, 'projectId': wtnpDataResult4.projectId });
                    }
                    if (wtnpDataResult5 != null) {
                        findedData.push({ "testname": wtnpDataResult5.testName, "failedCount": wtnpDataResult5.y, "colorCode": wtnpDataResult5.color, 'testtype': wtnpDataResult5.testType, 'projectId': wtnpDataResult5.projectId });
                    }

                    var result = {
                        "projectName": cat,
                        "data": findedData
                    };
                    DQMClickChannel.postMessage(JSON.stringify(result));
                }
            }
        },
        xAxis: {
            categories: projectNames,
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
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function () {
                    var newStr = '';
                    if (this.value.includes('<')) {
                        const myArray = this.value.split("<");
                        newStr = myArray[0] + "&lt" + myArray[1];
                    }
                    else {
                        newStr = this.value;
                    }
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                }
            }
        },
        yAxis: {
            min: 0,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[3],
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
                        var wtnpDataResult1 = '';
                        var wtnpDataResult2 = '';
                        var wtnpDataResult3 = '';
                        var wtnpDataResult4 = '';
                        var wtnpDataResult5 = '';
                        var findedData = [];
                        var cat = '';
                        if (event.point.category.includes("&lt;")) {
                            cat = event.point.category.replace("&lt;", "<");
                        }
                        else {
                            cat = event.point.category;
                        }
                        wtnpDataResult1 = wtnpData1.find(row => (row.projectId === cat));
                        wtnpDataResult2 = wtnpData2.find(row => (row.projectId === cat));
                        wtnpDataResult3 = wtnpData3.find(row => (row.projectId === cat));
                        wtnpDataResult4 = wtnpData4.find(row => (row.projectId === cat));
                        wtnpDataResult5 = wtnpData5.find(row => (row.projectId === cat));
                        if (wtnpDataResult1 != null) {
                            findedData.push({ "testname": wtnpDataResult1.testName, "failedCount": wtnpDataResult1.y, "colorCode": wtnpDataResult1.color, 'testtype': wtnpDataResult1.testType, 'projectId': wtnpDataResult1.projectId });
                        }
                        if (wtnpDataResult2 != null) {
                            findedData.push({ "testname": wtnpDataResult2.testName, "failedCount": wtnpDataResult2.y, "colorCode": wtnpDataResult2.color, 'testtype': wtnpDataResult2.testType, 'projectId': wtnpDataResult2.projectId });
                        }
                        if (wtnpDataResult3 != null) {
                            findedData.push({ "testname": wtnpDataResult3.testName, "failedCount": wtnpDataResult3.y, "colorCode": wtnpDataResult3.color, 'testtype': wtnpDataResult3.testType, 'projectId': wtnpDataResult3.projectId });
                        }
                        if (wtnpDataResult4 != null) {
                            findedData.push({ "testname": wtnpDataResult4.testName, "failedCount": wtnpDataResult4.y, "colorCode": wtnpDataResult4.color, 'testtype': wtnpDataResult4.testType, 'projectId': wtnpDataResult4.projectId });
                        }
                        if (wtnpDataResult5 != null) {
                            findedData.push({ "testname": wtnpDataResult5.testName, "failedCount": wtnpDataResult5.y, "colorCode": wtnpDataResult5.color, 'testtype': wtnpDataResult5.testType, 'projectId': wtnpDataResult5.projectId });
                        }

                        var result = {
                            "projectName": event.point.category,
                            "data": findedData
                        };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            },
        },
        series: [
            {
                data: wtnpData1
            },
            {
                data: wtnpData2
            },
            {
                data: wtnpData3
            },
            {
                data: wtnpData4
            },
            {
                data: wtnpData5
            }
        ],
    });
}

/*
*
    Digital Quality Summary
*
*/
function fetchSummaryFailureData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: (value.firstPass / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: ((value.firstPass + value.rework) / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {},
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumFailureChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Failure",
            data: failedData,
            color: '#e3032a'
        }]
    });
}

function fetchSummaryFirstPassYieldData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: (value.firstPass / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: ((value.firstPass + value.rework) / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: 0,
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
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
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumFirstPassChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "First Pass",
            data: firstPassData,
            color: '#14979c'
        }]
    });
}

function fetchSummaryYieldData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: (value.firstPass / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: ((value.firstPass + value.rework) / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: 0,
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
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
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumYieldChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Final Yield",
            data: finalYieldData,
            color: '#0c6540'
        }]
    });
}

function fetchSummaryVolumeData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: (value.firstPass / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: ((value.firstPass + value.rework) / (value.firstPass + value.rework + value.failed)) * 100, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x'
        },
        xAxis: {
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {},
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumVolumeChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Volume",
            data: totalVolumeData,
            color: '#d6ddd3'
        }]
    });
}

function fetchSummaryFailureDetailData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = totalFailedData + currentValue.failed;
            });

            totalFailResult.push([key, totalFailedData]);
            // if (params[2] == "VOLUME") {
            //     sorting = 'y';
            // }
            // else {
            //     sorting = 'x';
            // }
        }
    }

    totalFailResult.sort((a, b) => {
        if (params[2] == "VOLUME") {
            return b[1] - a[1];
        }
        else {
            return a[0] - b[0];
        }
    });

    var chartHeight = 350;
    var xMax = 5;
    if (totalFailResult.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = totalFailResult.length - 1;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalFailResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "projectId": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = totalFailResult.find((row => row[0] === this.value));
                    var newStr = '';
                    if (this.value.includes('<')) {
                        const myArray = this.value.split("<");
                        newStr = myArray[0] + "&lt" + myArray[1];
                    }
                    else {
                        newStr = this.value;
                    }

                    if (data != null) {
                        var str = data[1];
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {
            min: 0,
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
                pointWidth: 50,
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryFirstPassDetailData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFirstPassResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFP = 0;
            var totalRE = 0;
            var totalFA = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFP = totalFP + currentValue.firstPass;
                totalRE = totalRE + currentValue.rework;
                totalFA = totalFA + currentValue.failed;
            });

            var totalResult = (totalFP / (totalFP + totalRE + totalFA)) * 100;
            totalFirstPassResult.push([key, totalResult]);
            // if (params[2] == "VOLUME") {
            //     sorting = 'y';
            // }
            // else {
            //     sorting = 'x';
            // }
        }
    }

    totalFirstPassResult.sort((a, b) => {
        if (params[2] == "VOLUME") {
            return b[1] - a[1];
        }
        else {
            return a[0] - b[0];
        }
    });

    var chartHeight = 350;
    var xMax = 5;
    if (totalFirstPassResult.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = totalFirstPassResult.length - 1;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalFirstPassResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "projectId": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = totalFirstPassResult.find((row => row[0] === this.value));
                    var newStr = '';
                    if (this.value.includes('<')) {
                        const myArray = this.value.split("<");
                        newStr = myArray[0] + "&lt" + myArray[1];
                    }
                    else {
                        newStr = this.value;
                    }

                    if (data != null) {
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {},
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
                format: '{y:,.2f}'
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFirstPassResult,
        }],
    });
}

function fetchSummaryYieldDetailtData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalYieldResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFP = 0;
            var totalRE = 0;
            var totalFA = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFP = totalFP + currentValue.firstPass;
                totalRE = totalRE + currentValue.rework;
                totalFA = totalFA + currentValue.failed;
            });

            var totalResult = ((totalFP + totalRE) / (totalFP + totalRE + totalFA)) * 100;
            totalYieldResult.push([key, totalResult]);

            // if (params[2] == "VOLUME") {
            //     sorting = 'y';
            // }
            // else {
            //     sorting = 'x';
            // }
        }
    }

    totalYieldResult.sort((a, b) => {
        if (params[2] == "VOLUME") {
            return b[1] - a[1];
        }
        else {
            return a[0] - b[0];
        }
    });

    var chartHeight = 350;
    var xMax = 5;
    if (totalYieldResult.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = totalYieldResult.length - 1;
    }


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalYieldResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "projectId": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = totalYieldResult.find((row => row[0] === this.value));
                    var newStr = '';
                    if (this.value.includes('<')) {
                        const myArray = this.value.split("<");
                        newStr = myArray[0] + "&lt" + myArray[1];
                    }
                    else {
                        newStr = this.value;
                    }

                    if (data != null) {
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${newStr}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {},
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
                format: '{y:,.2f}'
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalYieldResult,
        }],
    });
}

function fetchSummaryFailureByProjectData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: value.firstPassYield, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: value.finalYield, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumFailureChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Failure",
            data: failedData,
            color: '#e3032a'
        }]
    });
}

function fetchSummaryFirstPassByProjectData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];
    var minValue = null;

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: value.firstPassYield, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: value.finalYield, dateStr: value.date });
                if (minValue == null) {
                    minValue = value.firstPassYield
                }
                else {
                    if (minValue > value.firstPassYield) {
                        minValue = value.firstPassYield;
                    }
                }
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
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
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumFirstPassChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "First Pass",
            data: firstPassData,
            color: '#14979c'
        }]
    });
}

function fetchSummaryYieldByProjectData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];
    var minValue = null;

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: value.firstPassYield, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: value.finalYield, dateStr: value.date });
                if (minValue == null) {
                    minValue = value.finalYield;
                }
                else {
                    if (minValue > value.finalYield) {
                        minValue = value.finalYield;
                    }
                }
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x',
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValueForPercentage(minValue),
            max: 100,
            tickInterval: 25,
        },
        legend: {
            enabled: false,
        },
        credits: {
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
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumYieldChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Final Yield",
            data: finalYieldData,
            color: '#0c6540'
        }]
    });
}

function fetchSummaryVolumeByProjectData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var failedData = [];
    var firstPassData = [];
    var finalYieldData = [];
    var totalVolumeData = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                var totalVolume = value.failed + value.firstPass + value.rework;
                failedData.push({ x: new Date(value.date).getTime(), y: value.failed, dateStr: value.date });
                totalVolumeData.push({ x: new Date(value.date).getTime(), y: totalVolume, dateStr: value.date });
                isValid = true;
                firstPassData.push({ x: new Date(value.date).getTime(), y: value.firstPassYield, dateStr: value.date });
                finalYieldData.push({ x: new Date(value.date).getTime(), y: value.finalYield, dateStr: value.date });
            }
        });

        if (!isValid) {
            firstPassData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
            finalYieldData.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'x'
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        yAxis: {
            // tickInterval: 100,
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var failureDataResult = failedData.find(row => (row.x === this.x));
                            var firstPassDataResult = firstPassData.find(row => (row.x === this.x));
                            var yieldResult = finalYieldData.find(row => (row.x === this.x));
                            var volumeResult = totalVolumeData.find(row => (row.x === this.x));

                            var result = { "date": this.dateStr, "failed": failureDataResult.y, "firstPass": firstPassDataResult.y, "finalYield": yieldResult.y, "volume": volumeResult.y };
                            DQMSumVolumeChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [{
            name: "Volume",
            data: totalVolumeData,
            color: '#d6ddd3'
        }]
    });
}

function fetchSummaryFailureByEquipmentData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = totalFailedData + currentValue.failed;
            });


            totalFailResult.push([key, totalFailedData]);
            if (params[2] == "VOLUME") {
                sorting = 'y';
            }
            else {
                sorting = 'x';
            }
        }
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
        },
        colors: ["#f4d444"],
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
                y: -35,
                align: 'left',
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px'
                },
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
                pointWidth: 50,
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
            },
            dataSorting: {
                enabled: true,
                sortKey: sorting
            },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryFirstPassByEquipmentData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFirstPassResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFP = 0;
            var totalRE = 0;
            var totalFA = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFP = totalFP + currentValue.firstPass;
                totalRE = totalRE + currentValue.rework;
                totalFA = totalFA + currentValue.failed;
            });

            var totalResult = (totalFP / (totalFP + totalRE + totalFA)) * 100;
            totalFirstPassResult.push([key, totalResult]);
            if (params[2] == "VOLUME") {
                sorting = 'y';
            }
            else {
                sorting = 'x';
            }
        }
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
        },
        colors: ["#f4d444"],
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
                y: -35,
                align: 'left',
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px'
                },
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
                pointWidth: 50,
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
                format: '{y:,.2f}'
            },
            dataSorting: {
                enabled: true,
                sortKey: sorting
            },
            data: totalFirstPassResult,
        }],
    });
}

function fetchSummaryYieldByEquipmentData(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalYieldResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFP = 0;
            var totalRE = 0;
            var totalFA = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFP = totalFP + currentValue.firstPass;
                totalRE = totalRE + currentValue.rework;
                totalFA = totalFA + currentValue.failed;
            });

            var totalResult = ((totalFP + totalRE) / (totalFP + totalRE + totalFA)) * 100;
            totalYieldResult.push([key, totalResult]);

            if (params[2] == "VOLUME") {
                sorting = 'y';
            }
            else {
                sorting = 'x';
            }
        }
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
        },
        colors: ["#f4d444"],
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
                y: -35,
                align: 'left',
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px'
                },
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "projectId": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
                pointWidth: 50,
            }
        },
        series: [{
            zoneAxis: 'x',
            dataLabels: {
                enabled: false,
                format: '{y:,.2f}'
            },
            dataSorting: {
                enabled: true,
                sortKey: sorting
            },
            data: totalYieldResult,
        }],
    });
}

function fetchSummaryFailureByEquipmentDetailData(...params) {
    var totalFailResult = [];
    var sorting = '';

    if (params[2] == "FILTER_BY_EQUIPMENT") {
        params[0].forEach(function (currentValue, index, arr) {
            totalFailResult.push([currentValue.equipmentName, currentValue.failed]);
        });
    }
    else {
        params[3].forEach(function (currentValue, index, arr) {
            totalFailResult.push([currentValue.testName, currentValue.failedCount]);
        });
    }



    // if (params[1] == "VOLUME") {
    //     sorting = 'y';
    // }
    // else {
    //     sorting = 'x';
    // }

    var chartHeight = 350;
    var xMax = 6;
    if (params[2] == "FILTER_BY_EQUIPMENT") {
        if (params[0].length > 5) {
            chartHeight = 600;
        }
        else {
            xMax = params[0].length - 1;
        }
    }
    else {
        if (params[3].length > 5) {
            chartHeight = 600;
        }
        else {
            xMax = params[3].length - 1;
        }
    }


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalFailResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "equipmentName": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var str = "";
                    if (params[2] == "FILTER_BY_EQUIPMENT") {
                        var data = params[0].find((row => row.equipmentName === this.value));
                        if (data != null) {
                            str = data.failed;
                            return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                        }
                    }
                    else {
                        var data = params[3].find((row => row.testName === this.value));
                        if (data != null) {
                            str = data.failedCount;
                            return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                        }
                    }

                    return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                }
            }
        },
        yAxis: {},
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {
                            var result = { "equipmentName": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: [{
            // zoneAxis: 'x',
            // dataLabels: {
            //     enabled: false,
            // },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryFirstPassByEquipmentDetailData(...params) {
    var totalFirstPassResult = [];
    var sorting = '';

    params[0].forEach(function (currentValue, index, arr) {
        totalFirstPassResult.push([currentValue.equipmentName, currentValue.firstPassYield]);
    });

    // if (params[1] == "VOLUME") {
    //     sorting = 'y';
    // }
    // else {
    //     sorting = 'x';
    // }

    var chartHeight = 350;
    var xMax = 6;
    if (params[0].length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = params[0].length - 1;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalFirstPassResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "equipmentName": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = params[0].find((row => row.equipmentName === this.value));
                    if (data != null) {
                        var str = data.firstPassYield;
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {},
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                point: {
                    events: {
                        click: function (event) {
                            var result = { "equipmentName": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: [{
            // zoneAxis: 'x',
            // dataLabels: {
            //     enabled: false,
            //     format: '{y:,.2f}'
            // },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFirstPassResult,
        }],
    });
}

function fetchSummaryYieldByEquipmentDetailData(...params) {
    var totalYieldResult = [];
    var sorting = '';

    params[0].forEach(function (currentValue, index, arr) {
        totalYieldResult.push([currentValue.equipmentName, currentValue.finalYield]);
    });

    // if (params[1] == "VOLUME") {
    //     sorting = 'y';
    // }
    // else {
    //     sorting = 'x';
    // }

    var chartHeight = 350;
    var xMax = 6;
    if (params[0].length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = params[0].length - 1;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            events: {
                click: function (event) {
                    var data = totalYieldResult[smallValueClickFunc(event).x];
                    if (data != null) {
                        var result = { "equipmentName": data[0], "value": data[1] };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        colors: ["#f4d444"],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = params[0].find((row => row.equipmentName === this.value));
                    if (data != null) {
                        var str = data.finalYield;
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {},
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
            },
            series: {
                point: {
                    events: {
                        click: function (event) {
                            var result = { "equipmentName": event.point.name, "value": event.point.y };
                            DQMClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: [{
            // zoneAxis: 'x',
            // dataLabels: {
            //     enabled: false,
            //     format: '{y:,.2f}'
            // },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalYieldResult,
        }],
    });
}

function fetchVolumeAndYieldData(...params) {
    var faileData = [];
    var passData = [];
    var reworkData = [];
    var firstPassYieldData = [];
    var finalYieldData = [];

    params[0].volumeByEquipment.map(function (row) {
        faileData.push([row.equipmentName, row.failed]);
        passData.push([row.equipmentName, row.firstPass]);
        reworkData.push([row.equipmentName, row.rework]);
        firstPassYieldData.push([row.equipmentName, row.firstPassYield]);
        finalYieldData.push([row.equipmentName, row.finalYield]);
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMTestResultVolumeAndYieldChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: "category",
        },
        yAxis: [
            {
                labels: { align: 'right', x: -3 },
                resize: { enabled: true },
                alignTicks: false
            },
            {
                opposite: true,
                labels: { align: 'top', x: -3 },
                min: 0,
                max: 100,
                gridLineWidth: 0,
                resize: { enabled: true },
                alignTicks: false
            }
        ],
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMTestResultVolumeAndYieldChannel.postMessage('');
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 6,
                    symbol: 'circle',
                },
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMTestResultVolumeAndYieldChannel.postMessage('');
                    }
                }
            }
        },
        series: [{
            type: 'column',
            name: params[3],
            data: faileData,
            color: '#e3032a',
        },
        {
            type: 'column',
            name: params[4],
            data: reworkData,
            color: '#f66a01',
        },
        {
            type: 'column',
            name: params[5],
            data: passData,
            color: '#73d329',
        },
        {
            type: 'line',
            name: params[2],
            data: firstPassYieldData,
            color: '#089fa7',
            yAxis: 1,

        },
        {
            type: 'line',
            name: params[1],
            data: finalYieldData,
            color: '#17721f',
            yAxis: 1,

        }]
    });
}

function fetchVolumeAndYieldDetailData(...params) {
    var faileData = [];
    var passData = [];
    var reworkData = [];
    var firstPassYieldData = [];
    var finalYieldData = [];
    var data = [];
    var xAxisData = [];

    if (params[1].match('EQUIPMENT_FIXTURE')) {
        params[0].volumeByEquipmentFixture.map(function (row) {
            data.push(row);
            faileData.push([row.fixtureId, row.failed]);
            passData.push([row.fixtureId, row.firstPass]);
            reworkData.push([row.fixtureId, row.rework]);
            firstPassYieldData.push([row.fixtureId, row.firstPassYield]);
            finalYieldData.push([row.fixtureId, row.finalYield]);
        });

        xAxisData.push({
            type: "category"
        });
        xAxisData.push({
            type: "category",
            linkedTo: 0,
            labels: {
                formatter: function () {
                    const pos = this.value.toString();
                    if (data[pos].equipmentName != null) {
                        return data[pos].equipmentName;
                    }
                    else {
                        return '';
                    }
                }
            },
        });
    }
    else {
        params[0].volumeByEquipment.map(function (row) {
            data.push(row);
            faileData.push([row.equipmentName, row.failed]);
            passData.push([row.equipmentName, row.firstPass]);
            reworkData.push([row.equipmentName, row.rework]);
            firstPassYieldData.push([row.equipmentName, row.firstPassYield]);
            finalYieldData.push([row.equipmentName, row.finalYield]);
        });

        xAxisData.push({
            type: "category"
        });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'x'
            }
        },
        xAxis: xAxisData,
        yAxis: [
            {
                labels: { align: 'right', x: -3 },
                resize: { enabled: true },
                alignTicks: false
            },
            {
                opposite: true,
                labels: { align: 'top', x: -3 },
                min: 0,
                max: 100,
                gridLineWidth: 0,
                resize: { enabled: true },
                alignTicks: false
            }
        ],
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[7],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    click: function (event) {
                        var dataResult = data.find(row => (row.equipmentName === event.point.name));
                        var result = {
                            "equipmentName": dataResult.equipmentName,
                            "fail": dataResult.failed,
                            "firstPass": dataResult.firstPass,
                            "rework": dataResult.rework,
                            "firstPassYield": dataResult.firstPassYield,
                            "finalYield": dataResult.finalYield
                        };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 6,
                    symbol: 'circle',
                },
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    click: function (event) {
                        var dataResult = data.find(row => (row.equipmentName === event.point.name));
                        var result = {
                            "equipmentName": dataResult.equipmentName,
                            "fail": dataResult.failed,
                            "firstPass": dataResult.firstPass,
                            "rework": dataResult.rework,
                            "firstPassYield": dataResult.firstPassYield,
                            "finalYield": dataResult.finalYield
                        };
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            }
        },
        series: [{
            type: 'column',
            name: params[4],
            data: faileData,
            color: '#e3032a',
        },
        {
            type: 'column',
            name: params[5],
            data: reworkData,
            color: '#f66a01',
        },
        {
            type: 'column',
            name: params[6],
            data: passData,
            color: '#73d329',
        },
        {
            type: 'line',
            name: params[3],
            data: firstPassYieldData,
            color: '#089fa7',
            yAxis: 1,

        },
        {
            type: 'line',
            name: params[2],
            data: finalYieldData,
            color: '#17721f',
            yAxis: 1,

        }]
    });
}

function fetchTestTimeDistributionData(...params) {
    var passBoxPlotData = [];
    var equipmentNames = [];
    var passOutlierData = [];
    var outliers = [];

    params[0].pass.boxPlotData.map(function (row) {
        equipmentNames.push(row.name);
        passBoxPlotData.push([row.high, row.q3, row.median, row.q1, row.low]);
    });

    params[0].pass.pointData.map(function (row) {
        outliers.push(row);
        passOutlierData.push([row.x, row.y]);
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'boxplot',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    DQMTestResultTestTimeChannel.postMessage('');
                },
                load() {
                    this.series[1].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    })
                }
            }
        },
        xAxis: {
            type: 'category',
            categories: equipmentNames,
        },
        yAxis: {
            min: 0
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            boxplot: {
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMTestResultTestTimeChannel.postMessage('');
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 3,
                    symbol: 'circle',
                },
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMTestResultTestTimeChannel.postMessage('');
                    }
                }
            }
        },
        series: [{
            name: params[1],
            data: passBoxPlotData,
            color: '#f4d444'
        }, {
            name: params[2],
            type: 'scatter',
            data: passOutlierData,
            color: '#F56A02'
        }]
    });
}

function fetchTestTimeDistributionDetailData(...params) {
    var passBoxPlotData = [];
    var equipmentNames = [];
    var passOutlierData = [];
    var outliers = [];
    var boxPlotDataList = [];
    var pointDataList = [];

    if (params[1].match('TESTTIME_PASS')) {
        params[0].pass.boxPlotData.map(function (row) {
            boxPlotDataList.push(row);
            equipmentNames.push(row.name);
            passBoxPlotData.push([row.high, row.q3, row.median, row.q1, row.low]);
        });

        params[0].pass.pointData.map(function (row) {
            pointDataList.push(row);
            outliers.push(row);
            passOutlierData.push([row.x, row.y]);
        });
    }
    else {
        params[0].fail.boxPlotData.map(function (row) {
            boxPlotDataList.push(row);
            equipmentNames.push(row.name);
            passBoxPlotData.push([row.high, row.q3, row.median, row.q1, row.low]);
        });

        params[0].fail.pointData.map(function (row) {
            pointDataList.push(row);
            outliers.push(row);
            passOutlierData.push([row.x, row.y]);
        });
    }



    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'boxplot',
            // height: 350,
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
            events: {
                load() {
                    this.series[1].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    })
                }
            }
        },
        xAxis: {
            type: 'category',
            categories: equipmentNames,
        },
        yAxis: {
            min: 0
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[4],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            boxplot: {
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    click: function (event) {
                        var result = boxPlotDataList.find((row) => row.name === event.point.category);
                        var finalResult = { "name": result.name, "high": result.high, "q3": result.q3, "median": result.median, "q1": result.q1, "low": result.low, "isClickScatter": false };
                        DQMClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 3,
                    symbol: 'circle',
                },
                states: {
                    inactive: {
                        opacity: 1
                    },
                },
                events: {
                    click: function (event) {
                        var result = pointDataList.find((row) => (row.x === event.point.x) && (row.y === event.point.y));
                        var finalResult = { "name": event.point.category, "x": result.x, "y": result.y, "outliers": result.outliers, "numberOfOutliers": result.numberOfOutliers, "isClickScatter": true };
                        DQMClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            }
        },
        series: [{
            name: params[2],
            data: passBoxPlotData,
            color: '#f4d444'
        }, {
            name: params[3],
            type: 'scatter',
            data: passOutlierData,
            color: '#F56A02'
        }]
    });
}

function fetchFailFinalDispositionData(...params) {
    var colors = ["#F5D745", "#FBA40A", "#F37719", "#DC5039", "#BB3754", "#932567", "#6A176E", '#51559B', "#115FB2", "#079BBF", "#05A0A7", '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0'];
    const map1 = new Map(Object.entries(params[1]));
    var finalDispositionData = [];
    var colorIndex = 0;
    for (let [key, value] of map1.entries()) {
        var dataItem = [];

        value.forEach(function (currentValue, index, arr) {
            const finalStr = currentValue.firstStatus.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toUpperCase());
            dataItem.push([finalStr, currentValue.count]);
        });

        const finalKeyStr = key.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toUpperCase());
        if (key.match('passed')) {
            finalDispositionData.push({ name: finalKeyStr, data: dataItem, color: '#73d329' });
        }
        else {
            finalDispositionData.push({ name: finalKeyStr, data: dataItem, color: colors[colorIndex] });
            colorIndex++;
        }
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            spacingLeft: 0,
            spacingRight: 0,
            events: {
                click: function (event) {
                    DQMTestResultFirstFailChannel.postMessage('');
                },
            }
        },
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
        },
        yAxis: {},
        credits: {
            enabled: false
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
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    },
                    click: function (event) {
                        DQMTestResultFirstFailChannel.postMessage('');
                    }
                }
            },
        },
        series: finalDispositionData,
    });
}

function fetchFailFinalDispositionDetailData(...params) {
    var colors = ["#F5D745", "#FBA40A", "#F37719", "#DC5039", "#BB3754", "#932567", "#6A176E", '#51559B', "#115FB2", "#079BBF", "#05A0A7", '#72F5D4', '#4ECDC4', '#007EC7', '#00DAF0', '#B9E8E0'];
    const map1 = new Map(Object.entries(params[1]));
    var finalDispositionData = [];
    var largestValue = 0;
    var colorIndex = 0;
    for (let [key, value] of map1.entries()) {
        var dataItem = [];
        value.forEach(function (currentValue, index, arr) {
            const finalStr = currentValue.firstStatus.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toUpperCase());
            if (params[2].find((row => row.projectId === currentValue.firstStatus)).isSelected) {
                dataItem.push([finalStr, currentValue.count]);
            }
        });

        if (dataItem.length > 0) {
            if (largestValue > 0) {
                if (largestValue < dataItem.length) {
                    largestValue = dataItem.length;
                }
            }
            else {
                largestValue = dataItem.length;
            }
            const finalKeyStr = key.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toUpperCase());
            if (key.match('passed')) {
                finalDispositionData.push({ name: finalKeyStr, data: dataItem, color: '#73d329' });
            }
            else {
                finalDispositionData.push({ name: finalKeyStr, data: dataItem, color: colors[colorIndex] });
                colorIndex++;
            }
        }
    }

    var chartFDHeight = 350;
    if (largestValue > 5) {
        chartFDHeight = 600;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 600,
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'x'
            },
            events: {
                click: function (event) {
                    let pointSelected;
                    if (chart1 != null && chart1 != undefined) {
                        const chart = chart1;
                        const xPos = chart.xAxis[0].toValue(event.chartY);
                        chart.series.forEach((mData) => {
                            mData.points.forEach((point) => {
                                if (xPos >= point.x - 0.5 && xPos <= point.x + 0.5) {
                                    pointSelected = point;
                                }
                            });
                        });


                        var finalResult = [];
                        var totalCount = 0;
                        const mStr = pointSelected.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase());
                        var result = params[0].finalDispositionStruct.filter((row => row.firstStatus === mStr));
                        result.forEach(function (value) {
                            totalCount = totalCount + value.count;
                            var colorCode = finalDispositionData.find((row) => row.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase()) === value.lastStatus).color;
                            finalResult.push({
                                "firstStatus": value.firstStatus,
                                "count": value.count,
                                "lastStatus": value.lastStatus,
                                "colorCode": colorCode,
                            });
                        });

                        finalResult.push({
                            "firstStatus": '',
                            "count": totalCount,
                            "lastStatus": 'Total',
                            "colorCode": '#ffffff',
                        });
                        DQMClickChannel.postMessage(JSON.stringify(finalResult));

                    }
                }
            }
        },
        xAxis: {
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
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function () {
                    return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                }
            }
        },
        yAxis: {},
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[3],
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
                        var finalResult = [];
                        var totalCount = 0;
                        const mStr = event.point.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase());
                        var result = params[0].finalDispositionStruct.filter((row => row.firstStatus === mStr));
                        result.forEach(function (value) {
                            totalCount = totalCount + value.count;
                            var colorCode = finalDispositionData.find((row) => row.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase()) === value.lastStatus).color;
                            finalResult.push({
                                "firstStatus": value.firstStatus,
                                "count": value.count,
                                "lastStatus": value.lastStatus,
                                "colorCode": colorCode,
                            });
                        });

                        finalResult.push({
                            "firstStatus": '',
                            "count": totalCount,
                            "lastStatus": 'Total',
                            "colorCode": '#ffffff',
                        });
                        DQMClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
            // series: {
            //     pointPadding: 0.5,
            //     groupPadding: 1,
            // }
        },
        series: finalDispositionData,
    });
}

function fetchTestTypeFailureCountData(...params) {
    const map1 = new Map(Object.entries(params[1]));
    var testTypeFailureData = [];
    var xCategories = [];
    var yCategories = [];
    var xIndex = 0;
    for (let [key, value] of map1.entries()) {
        xCategories.push(key);
        var dataItem = [];

        value.forEach(function (currentValue, yIndex, arr) {
            yCategories.push(currentValue.testType);
            dataItem.push([xIndex, yIndex, currentValue.failureCount]);
        });
        testTypeFailureData.push({
            name: key,
            data: dataItem,
            dataLabels: {
                enabled: true,
                color: '#000000'
            },
            borderWidth: 1,
            borderColor: 'black',
        });
        xIndex++;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'heatmap',
            spacingLeft: 0,
            spacingRight: 0,
            events: {
                click: function (event) {
                    DQMTestResultComponentFailureChannel.postMessage('');
                }
            }
        },
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            categories: xCategories,
            title: {
                text: null
            },
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            categories: yCategories,
        },
        colorAxis: {
            min: 0,
            stops: [
                [0, 'rgb(225,225,225)'],
                [1, '#f4d744']
            ],
        },
        legend: {
            align: 'right',
            layout: 'vertical',
            verticalAlign: 'middle',
            symbolHeight: 150,
            floating: false,
            x: 0,
            y: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.0)',
            borderColor: '#ffffff',
            borderWidth: 0,
            itemStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            itemHoverStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            itemHiddenStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            title: {
                style: {
                    color: '#B1B1B1',
                    fontSize: '13px'
                }
            }
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            heatmap: {
                data: {
                    events: {
                        click: function (event) {
                            DQMTestResultComponentFailureChannel.postMessage('');
                        }
                    }
                },
                events: {
                    click: function (event) {
                        DQMTestResultComponentFailureChannel.postMessage('');
                    }
                }
            }
        },
        series: testTypeFailureData,
    });
}

function fetchTestTypeFailureCountDetailData(...params) {
    const map1 = new Map(Object.entries(params[1]));
    var testTypeFailureData = [];
    var xCategories = [];
    var yCategories = [];
    var xIndex = 0;
    for (let [key, value] of map1.entries()) {
        xCategories.push(key);
        var dataItem = [];

        value.forEach(function (currentValue, yIndex, arr) {
            yCategories.push(currentValue.testType);
            dataItem.push([xIndex, yIndex, currentValue.failureCount]);
        });
        testTypeFailureData.push({
            name: key,
            data: dataItem,
            dataLabels: {
                enabled: true,
                color: '#000000'
            },
            borderWidth: 1,
            borderColor: 'black',
        });
        xIndex++;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'heatmap',
            // height: 350,
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
        },
        xAxis: {
            type: 'category',
            categories: xCategories,
            title: {
                text: null
            },
        },
        yAxis: {
            categories: yCategories,
        },
        colorAxis: {
            min: 0,
            stops: [
                [0, 'rgb(225,225,225)'],
                [1, '#f4d744']
            ],
        },
        legend: {
            align: 'right',
            layout: 'vertical',
            verticalAlign: 'middle',
            symbolHeight: 150,
            floating: false,
            x: 0,
            y: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.0)',
            borderColor: '#ffffff',
            borderWidth: 0,
            itemStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            itemHoverStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            itemHiddenStyle: {
                color: '#B1B1B1',
                fontSize: '13px',
            },
            title: {
                style: {
                    color: '#B1B1B1',
                    fontSize: '13px'
                }
            }
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            },
            text: params[3],
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            heatmap: {
                events: {
                    click: function (event) {
                        var testType = yCategories[event.point.y];
                        var fixtureId = xCategories[event.point.x];
                        var result = {
                            "testType": testType,
                            "fixtureId": fixtureId
                        }
                        DQMClickChannel.postMessage(JSON.stringify(result));
                    }
                }
            },
        },
        series: testTypeFailureData,
    });
}

function fetchWorstTestNamesData(...params) {
    var testNamesData = [];
    var xCategories = [];

    params[0].data.map(function (value) {
        // xCategories.push(value.testName);
        testNamesData.push([value.testName, value.count]);
        // testNamesData.push([value.testName, value.count]);
        // testNamesData.push({ name: value.testName, data: [value.count] });
    });

    var chartHeight = 350;
    var xMax = 6;
    if (params[0].data.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = params[0].data.length - 1;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            // zoomType: 'x',
        },
        colors: ['#f4d745'],
        xAxis: {
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = params[0].data.find((row => row.testName === this.value));
                    if (data != null) {
                        var str = data.count;
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {
            min: 0,
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
                        // var finalResult = [];
                        // const mStr = event.point.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase());
                        // var result = params[0].finalDispositionStruct.filter((row => row.firstStatus === mStr));
                        // result.forEach(function (value) {
                        //     var colorCode = finalDispositionData.find((row) => row.name.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toLowerCase()) === value.lastStatus).color;
                        //     finalResult.push({
                        //         "firstStatus": value.firstStatus,
                        //         "count": value.count,
                        //         "lastStatus": value.lastStatus,
                        //         "colorCode": colorCode,
                        //     });
                        // });
                        // DQMClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: [{
            data: testNamesData,
        }]
    });
}

function fetchTestTypeWorstTestNamesData(...params) {
    var testNamesData = [];

    params[0].data.map(function (value) {
        testNamesData.push([value.testName, value.count]);
    });

    var chartHeight = 350;
    var xMax = 6;
    if (params[0].data.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = params[0].data.length - 1;
    }
    const categories = [...new Array(100)].map(() => "Sample Name");
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            // zoomType: 'x',
        },
        colors: ['#f4d745'],
        xAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            type: 'category',
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            min: 0,
            max: xMax,
            tickLength: 0,
            labels: {
                x: 0,
                y: -20,
                align: 'left',
                verticalAlign: 'top',
                useHTML: true,
                allowOverlap: true,
                style: {
                    color: 'rgba(177, 177, 177, 0.4)',
                    fontSize: '11px',
                },
                formatter: function (event) {
                    var data = params[0].data.find((row => row.testName === this.value));
                    if (data != null) {
                        var str = data.count;
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${this.value}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #ffffff;"> ${str}</span>
                            </div>
                          `
                    }
                    else {
                        return `
                        <div style="width: 100px; height: 30px;">
                          ${this.value}
                        </div>
                      `
                    }
                }
            }
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            min: 0,
            // max: 1500,
        },
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
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
                        var data = params[0].data.find((row => row.testName === event.point.name));
                        DQMClickChannel.postMessage(event.point.name);
                    }
                }
            },
        },
        series: [{
            data: testNamesData,
        }]
    });
}

function fetchDailyCpkDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var cpkData = [];
    var minValue = null;
    params[0].data.forEach(function (value) {
        cpkData.push({ x: new Date(value.latestTimeStamp).getTime(), y: Number(value.cpk), dataObj: value });
        if (minValue == null) {
            minValue = Number(value.cpk);
        }
        else {
            if (minValue > Number(value.cpk)) {
                minValue = Number(value.cpk);
            }
        }
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
            type: "datetime",
            min: startDate,
            max: endDate,
        },
        yAxis: {
            min: minValue,
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 2);
                }
            },
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[3],
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
                            // var cpkDataResult = '';
                            // cpkDataResult = cpkData.find(row => (row.x === this.x));
                            // var result = { "date": this.dateStr, "cpkValue": cpkDataResult.y };
                            DQMCpkClickChannel.postMessage(JSON.stringify(this.dataObj));
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

function fetchRmaTestResultCpkDetailData(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var cpkData = [];
    var minValue = null;
    params[0].data.forEach(function (value) {
        cpkData.push({ x: new Date(value.latestTimeStamp).getTime(), y: Number(value.cpk), dateStr: value.latestTimeStamp, obj: value });
        if (minValue == null) {
            minValue = Number(value.cpk);
        }
        else {
            if (minValue > Number(value.cpk)) {
                minValue = Number(value.cpk);
            }
        }
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
            type: "datetime",
            labels: {
                formatter: function () {
                    return Highcharts.dateFormat('%e. %b', this.value);
                }
            },
        },
        yAxis: {
            min: minValue,
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
            text: params[3],
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
                            DQMCpkClickChannel.postMessage(JSON.stringify(cpkDataResult.obj));
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

function fetchCpkByTestNameData(...params) {
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var total = params[0].length;
    var seriesData = [];

    params[0].forEach(function (mData) {
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([mData.testName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([mData.testName, 0]);
        }
    });

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / total) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / total) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / total) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / total) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / total) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMAnalogCpkTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            type: "category",
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMAnalogCpkTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCpkPinsByTestNameData(...params) {
    const map1 = new Map(Object.entries(params[1]));
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var total = 0;
    var seriesData = [];

    params[0].forEach(function (mData) {
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([mData.testName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([mData.testName, 0]);
        }
    });

    // for (let [key, value] of map1.entries()) {
    //     if (params[2].some(e => e === key)) {
    //         total = total + value.length;
    //         value.forEach(function (mData) {
    //             if (mData.cpk != null) {
    //                 if (mData.cpk <= 1) {
    //                     threeSigmaTest.push([mData.testName, mData.cpk]);
    //                 }
    //                 else if (mData.cpk > 1 && mData.cpk <= 1.33) {
    //                     fourSigmaTest.push([mData.testName, mData.cpk]);
    //                 }
    //                 else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
    //                     fiveSigmaTest.push([mData.testName, mData.cpk]);
    //                 }
    //                 else if (mData.cpk > 1.67 && mData.cpk <= 2) {
    //                     sixSigmaTest.push([mData.testName, mData.cpk]);
    //                 }
    //                 else if (mData.cpk > 2) {
    //                     otherSigmaTest.push([mData.testName, mData.cpk]);
    //                 }
    //             }
    //             else {
    //                 threeSigmaTest.push([mData.testName, 0]);
    //             }
    //         });
    //     }
    // }

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / total) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / total) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / total) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / total) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / total) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMPinsCpkTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
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
            type: "category",
        },
        yAxis: {
            gridLineColor: 'rgba(177, 177, 177, 0.4)',
            labels: {
                style: {
                    color: 'rgba(177, 177, 177, 0.4)'
                }
            },
            lineColor: 'rgba(177, 177, 177, 0.4)',
            minorGridLineColor: 'rgba(177, 177, 177, 0.4)',
            tickColor: 'rgba(177, 177, 177, 0.4)',
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMPinsCpkTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCpkShortsByTestNameData(...params) {
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var total = 0;
    var seriesData = [];

    params[0].forEach(function (mData) {
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([mData.testName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([mData.testName, 0]);
        }
    });

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / params[0].length) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / params[0].length) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / params[0].length) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMCpkShortsTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            type: "category",
            labels: {
                formatter: function (event) {
                    if (this.value.includes("EDLShorts|short>")) {
                        return this.value.substring(this.value.indexOf('>') + 1);
                    }

                    return this.value;
                }
            }
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0].includes(">") ? otherResult[0].substring(otherResult[0].indexOf('>') + 1) : otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0].includes(">") ? sixResult[0].substring(sixResult[0].indexOf('>') + 1) : sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0].includes(">") ? fiveResult[0].substring(fiveResult[0].indexOf('>') + 1) : fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0].includes(">") ? fourResult[0].substring(fourResult[0].indexOf('>') + 1) : fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0].includes(">") ? threeResult[0].substring(threeResult[0].indexOf('>') + 1) : threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMCpkShortsTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCpkVtepByTestNameData(...params) {
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var seriesData = [];

    params[0].forEach(function (mData) {
        var xCatName = mData.source + " (" + mData.destination + ")";
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([xCatName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([xCatName, 0]);
        }
    });

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / params[0].length) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / params[0].length) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / params[0].length) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMVtepCpkTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            type: "category",
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0].includes(">") ? otherResult[0].substring(otherResult[0].indexOf('>') + 1) : otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0].includes(">") ? sixResult[0].substring(sixResult[0].indexOf('>') + 1) : sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0].includes(">") ? fiveResult[0].substring(fiveResult[0].indexOf('>') + 1) : fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0].includes(">") ? fourResult[0].substring(fourResult[0].indexOf('>') + 1) : fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0].includes(">") ? threeResult[0].substring(threeResult[0].indexOf('>') + 1) : threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMVtepCpkTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCpkFuncByTestNameData(...params) {
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var seriesData = [];

    params[0].forEach(function (mData) {
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([mData.testName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([mData.testName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([mData.testName, 0]);
        }
    });

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / params[0].length) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / params[0].length) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / params[0].length) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMFuncCpkTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            type: "category",
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0].includes(">") ? otherResult[0].substring(otherResult[0].indexOf('>') + 1) : otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0].includes(">") ? sixResult[0].substring(sixResult[0].indexOf('>') + 1) : sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0].includes(">") ? fiveResult[0].substring(fiveResult[0].indexOf('>') + 1) : fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0].includes(">") ? fourResult[0].substring(fourResult[0].indexOf('>') + 1) : fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0].includes(">") ? threeResult[0].substring(threeResult[0].indexOf('>') + 1) : threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMFuncCpkTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCpkXVtepByTestNameData(...params) {
    var threeSigmaTest = [];
    var fourSigmaTest = [];
    var fiveSigmaTest = [];
    var sixSigmaTest = [];
    var otherSigmaTest = [];
    var seriesData = [];

    params[0].forEach(function (mData) {
        var xCatName = mData.source + " (" + mData.destination + ")";
        if (mData.cpk != null) {
            if (mData.cpk <= 1) {
                threeSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1 && mData.cpk <= 1.33) {
                fourSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1.33 && mData.cpk <= 1.67) {
                fiveSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 1.67 && mData.cpk <= 2) {
                sixSigmaTest.push([xCatName, mData.cpk]);
            }
            else if (mData.cpk > 2) {
                otherSigmaTest.push([xCatName, mData.cpk]);
            }
        }
        else {
            threeSigmaTest.push([xCatName, 0]);
        }
    });

    otherSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    sixSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fiveSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    fourSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    threeSigmaTest.sort((a, b) => {
        return b[1] - a[1];
    });

    var sixSigma = ((sixSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fiveSigma = ((fiveSigmaTest.length / params[0].length) * 100).toFixed(2);
    var fourSigma = ((fourSigmaTest.length / params[0].length) * 100).toFixed(2);
    var threeSigma = ((threeSigmaTest.length / params[0].length) * 100).toFixed(2);
    var otherSigma = ((otherSigmaTest.length / params[0].length) * 100).toFixed(2);
    var calResult = {
        "sixSigma": "6 Sigma (Between 1.67 to 2)",
        "sixSigmaValue": sixSigma,
        "fiveSigma": "5 Sigma (Between 1.33 to 1.67)",
        "fiveSigmaValue": fiveSigma,
        "fourSigma": "4 Sigma (Between 1 to 1.33)",
        "fourSigmaValue": fourSigma,
        "threeSigma": "3 Sigma (Less than 1)",
        "threeSigmaValue": threeSigma,
        "otherSigma": "> 6 Sigma",
        "otherSigmaValue": otherSigma
    }
    DQMXVTEPCpkTestNameChannel.postMessage(JSON.stringify(calResult));

    if (params[1].match("ALL")) {
        seriesData.push({ name: "CPK", data: otherSigmaTest, color: 'rgb(132,215,106)' });
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
        seriesData.push({ name: "5 Sigma", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }
    else if (params[1].match("SIGMA_6")) {
        seriesData.push({ name: "6 Sigma", data: sixSigmaTest, color: 'rgb(49,148,86)' });
    }
    else if (params[1].match("SIGMA_5")) {
        seriesData.push({ name: "CPK", data: fiveSigmaTest, color: 'rgb(245,215,69)' });
    }
    else if (params[1].match("SIGMA_4")) {
        seriesData.push({ name: "4 Sigma", data: fourSigmaTest, color: 'rgb(251,164,10)' });
    }
    else if (params[1].match("SIGMA_3")) {
        seriesData.push({ name: "3 Sigma", data: threeSigmaTest, color: 'rgb(240,80,80)' });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'area',
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            }
        },
        xAxis: {
            type: "category",
        },
        yAxis: {
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[2],
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
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
                            var otherResult = otherSigmaTest.find((row => row[0] === event.point.name));
                            var sixResult = sixSigmaTest.find((row => row[0] === event.point.name));
                            var fiveResult = fiveSigmaTest.find((row => row[0] === event.point.name));
                            var fourResult = fourSigmaTest.find((row => row[0] === event.point.name));
                            var threeResult = threeSigmaTest.find((row => row[0] === event.point.name));
                            var finalResult = {};
                            if (otherResult != null) {
                                finalResult = { "testname": otherResult[0].includes(">") ? otherResult[0].substring(otherResult[0].indexOf('>') + 1) : otherResult[0], "sigmaType": "CPK", "value": event.point.y, "colorCode": "#84D76A" };
                            }
                            if (sixResult != null) {
                                finalResult = { "testname": sixResult[0].includes(">") ? sixResult[0].substring(sixResult[0].indexOf('>') + 1) : sixResult[0], "sigmaType": "6 Sigma", "value": event.point.y, "colorCode": "#319456" };
                            }
                            if (fiveResult != null) {
                                finalResult = { "testname": fiveResult[0].includes(">") ? fiveResult[0].substring(fiveResult[0].indexOf('>') + 1) : fiveResult[0], "sigmaType": "5 Sigma", "value": event.point.y, "colorCode": "#F5D745" };
                            }
                            if (fourResult != null) {
                                finalResult = { "testname": fourResult[0].includes(">") ? fourResult[0].substring(fourResult[0].indexOf('>') + 1) : fourResult[0], "sigmaType": "4 Sigma", "value": event.point.y, "colorCode": "#FBA40A" };
                            }
                            if (threeResult != null) {
                                finalResult = { "testname": threeResult[0].includes(">") ? threeResult[0].substring(threeResult[0].indexOf('>') + 1) : threeResult[0], "sigmaType": "3 Sigma", "value": event.point.y, "colorCode": "#F05050" };
                            }
                            DQMXVTEPCpkTestNameClickChannel.postMessage(JSON.stringify(finalResult));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}


function fetchTestResultByTestNameData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var thresholdData = [];
    var seriesData = [];

    params[0].data.forEach(function (value) {
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else {
            failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }

        if (params[1] != null && params[1].length > 0) {
            if (params[1].match("Jumper") || params[1].match("Switch")) {
                if (value.upperLimit === '+9.999999E+99' || value.upperLimit === '9.999999E99') {
                    thresholdData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
                } else {
                    thresholdData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
                }
            }
            else {
                if (value.lowerLimit != null && value.lowerLimit.length > 0) {
                    lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
                }

                if (value.upperLimit != null && value.upperLimit.length > 0) {
                    upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
                }
            }
        }
        else {
            if (value.lowerLimit != null && value.lowerLimit.length > 0) {
                lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
            }

            if (value.upperLimit != null && value.upperLimit.length > 0) {
                upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
            }
        }

    });

    seriesData.push({ name: params[3], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    if (params[1].match("Jumper") || params[1].match("Switch")) {
        seriesData.push({ name: params[7], data: thresholdData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    }
    else {
        seriesData.push({ name: params[8], data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
        seriesData.push({ name: params[9], data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    }

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
            type: "datetime",
        },
        yAxis: {
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
            text: params[2],
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
                    events: {
                        click: function (event) {
                            DQMAnalogCpkTestResultChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchHistogramData(...params) {
    var highestValue = 0;
    var histoData = [];
    var histogramData = [];
    params[0].binList.forEach(function (mData) {
        histoData.push({ x: mData.start, y: mData.value });

        if (highestValue < mData.value) {
            highestValue = mData.value;
        }
    });

    var minus3 = {
        name: params[2],
        color: '#DC5039',
        borderColor: 'rgb(220,80,57)',
        legendIndex: 2,
        grouping: false,
        data: [{ x: params[0].meanMinus3Std, y: highestValue }]
    };
    histogramData.push(minus3);

    var minus2 = {
        name: params[3],
        color: '#F37719',
        borderColor: 'rgb(243,119,25)',
        legendIndex: 1,
        grouping: false,
        data: [{ x: params[0].meanMinus2Std, y: highestValue }]
    };
    histogramData.push(minus2);

    var minus1 = {
        name: params[4],
        color: '#FBA40A',
        borderColor: 'rgb(251,164,10)',
        legendIndex: 0,
        grouping: false,
        data: [{ x: params[0].meanMinus1Std, y: highestValue }]
    };
    histogramData.push(minus1);

    var mean = {
        name: params[5],
        color: '#F5D745',
        borderColor: 'rgb(245,215,69)',
        legendIndex: 3,
        grouping: false,
        data: [{ x: params[0].mean, y: highestValue }]
    };
    histogramData.push(mean);

    var plus1 = {
        name: params[6],
        color: '#FBA40A',
        borderColor: 'rgb(251,164,10)',
        legendIndex: 4,
        grouping: false,
        data: [{ x: params[0].meanPlus1Std, y: highestValue }]
    };
    histogramData.push(plus1);

    var plus2 = {
        name: params[7],
        color: '#F37719',
        borderColor: 'rgb(243,119,25)',
        legendIndex: 5,
        grouping: false,
        data: [{ x: params[0].meanPlus2Std, y: highestValue }]
    };
    histogramData.push(plus2);

    var plus3 = {
        name: params[8],
        color: '#DC5039',
        borderColor: 'rgb(220,80,57)',
        legendIndex: 6,
        grouping: false,
        data: [{ x: params[0].meanPlus3Std, y: highestValue }]
    };
    histogramData.push(plus3);

    histogramData.push({
        grouping: false,
        name: params[9],
        legendIndex: 7,
        color: '#ffffff80',
        borderColor: '#FFFFFF',
        borderWidth: 1,
        groupPadding: 0,
        pointPadding: 0,
        data: histoData
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'xy',
            panning: {
                enabled: true,
                type: 'xy'
            },
        },
        xAxis: {
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 3);
                }
            }
        },
        yAxis: {
            min: 0,
            max: highestValue,
            allowDecimals: false,
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[1],
        },
        legend: {
            enabled: true,
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointPadding: 0.5,
                borderWidth: 0.5,
            },
            scatter: {
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                }
            },
            series: {
                point: {
                    events: {
                        click: function (event) {
                            var result = {};
                            if (this.series.name.match(params[9])) {
                                result = {
                                    "binStart": event.point.x,
                                    "binValue": event.point.y
                                };
                            }
                            else {
                                result = {
                                    "name": this.series.name,
                                    "value": event.point.x,
                                    "colorCode": this.series.color
                                }
                            }

                            DQMHistogramBarClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            },
        },
        series: histogramData,
    });
}

function fetchSmallHistogramData(...params) {
    var highestValue = 0;
    var histoData = [];
    var smallHistogramData = [];
    params[0].binList.forEach(function (mData) {
        histoData.push({ x: mData.start, y: mData.value });

        if (highestValue < mData.value) {
            highestValue = mData.value;
        }
    });

    var minus3 = {
        name: params[2],
        color: '#DC5039',
        borderColor: 'rgb(220,80,57)',
        legendIndex: 2,
        grouping: false,
        data: [{ x: params[0].meanMinus3Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(minus3);

    var minus2 = {
        name: params[3],
        color: '#F37719',
        borderColor: 'rgb(243,119,25)',
        legendIndex: 1,
        grouping: false,
        data: [{ x: params[0].meanMinus2Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(minus2);

    var minus1 = {
        name: params[4],
        color: '#FBA40A',
        borderColor: 'rgb(251,164,10)',
        legendIndex: 0,
        grouping: false,
        data: [{ x: params[0].meanMinus1Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(minus1);

    var mean = {
        name: params[5],
        color: '#F5D745',
        borderColor: 'rgb(245,215,69)',
        legendIndex: 3,
        grouping: false,
        data: [{ x: params[0].mean, y: highestValue + 15 }]
    };
    smallHistogramData.push(mean);

    var plus1 = {
        name: params[6],
        color: '#FBA40A',
        borderColor: 'rgb(251,164,10)',
        legendIndex: 4,
        grouping: false,
        data: [{ x: params[0].meanPlus1Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(plus1);

    var plus2 = {
        name: params[7],
        color: '#F37719',
        borderColor: 'rgb(243,119,25)',
        legendIndex: 5,
        grouping: false,
        data: [{ x: params[0].meanPlus2Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(plus2);

    var plus3 = {
        name: params[8],
        color: '#DC5039',
        borderColor: 'rgb(220,80,57)',
        legendIndex: 6,
        grouping: false,
        data: [{ x: params[0].meanPlus3Std, y: highestValue + 15 }]
    };
    smallHistogramData.push(plus3);

    smallHistogramData.push({
        grouping: false,
        type: 'spline',
        name: params[9],
        legendIndex: 7,
        color: 'rgb(255, 255, 255)',
        borderWidth: 1,
        groupPadding: 0,
        pointPadding: 0,
        data: histoData
    });

    smallHistogramData.push({
        name: 'Lower Limit',
        color: '#C8C8C8',
        grouping: false,
        data: [{ x: params[0].lowerLimit, y: highestValue + 15 }]
    });
    smallHistogramData.push({
        name: 'Upper Limit',
        color: '#C8C8C8',
        grouping: false,
        data: [{ x: params[0].upperLimit, y: highestValue + 15 }]
    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 30,
            zoomType: 'x',
            panning: {
                enabled: true,
                type: 'x'
            },
        },
        xAxis: {
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 3);
                }
            }
        },
        yAxis: {
            min: 0,
            max: highestValue,
            allowDecimals: false,
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {
            column: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                pointPadding: 0.5,
                borderWidth: 0,
                point: {
                    events: {
                        click: function (event) {
                            // var result = {
                            //     "name": event.point.name,
                            //     "value": event.point.x,
                            //     "colorCode": event.point.color
                            // }
                            // DQMSmallHistogramColumnClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            },
            spline: {
                marker: {
                    symbol: 'circle'
                },
                point: {
                    events: {
                        click: function (event) {
                            var result = {};
                            result = {
                                "binStart": event.point.x,
                                "binValue": event.point.y
                            };
                            DQMSmallHistogramSplineClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                },
            }
        },
        series: smallHistogramData,
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
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            if (value.serialNumber.match(params[1])) {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            if (value.serialNumber.match(params[1])) {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                if (value.serialNumber.match(params[1])) {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
            else {
                if (value.serialNumber.match(params[1])) {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
        }
        else {
            if (value.serialNumber.match(params[1])) {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
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
    seriesData.push({ name: params[8], data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[9], data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });

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
            type: "datetime",
        },
        yAxis: {
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
            text: params[2],
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
                    events: {
                        click: function (event) {
                            DQMClickChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchRmaCoRelationData(...params) {
    var seriesData = [
        { name: params[5], data: [], color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } },
        { name: params[6], data: [], color: 'rgb(245,215,69)', marker: { radius: 2, symbol: 'circle' } }
    ];

    params[0].data.TestOne.forEach(function (value, i) {
        var graphData = {
            y: +params[0].data.TestOne[i].measured,
            x: +params[0].data.TestTwo[i].measured,
            type: 'co-relation',
            test1: +params[0].data.TestOne[i].measured,
            test1Name: params[2],
            test2: +params[0].data.TestTwo[i].measured,
            test2Name: params[3],
            fixtureId: params[0].data.TestOne[i].fixtureId,
            lowerLimit1: params[0].data.TestOne[i].lowerLimit,
            lowerLimit2: params[0].data.TestTwo[i].lowerLimit,
            upperLimit1: params[0].data.TestOne[i].upperLimit,
            upperLimit2: params[0].data.TestTwo[i].upperLimit,
            hasAnomaly: 'Yes',
            serialNumber: params[0].data.TestOne[i].serialNumber,
            dataObj: value,
        };

        if (params[1].match(params[0].data.TestOne[i].serialNumber)) {
            seriesData[1].data.push(graphData);
        } else if (
            (params[0].data.TestOne[i].status.match("PASSED") && params[0].data.TestTwo[i].status.match("PASSED")) ||
            (params[0].data.TestOne[i].status.match("PASS") && params[0].data.TestTwo[i].status.match("PASS")) ||
            (params[0].data.TestOne[i].status.match("PASSED") && params[0].data.TestTwo[i].status.match("PASS")) ||
            (params[0].data.TestOne[i].status.match("PASS") && params[0].data.TestTwo[i].status.match("PASSED"))
        ) {
            graphData.hasAnomaly = 'No';
            seriesData[0].data.push(graphData);
        }
    });


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
                }
            }
        },
        xAxis: {
            title: { enabled: true, text: params[3] },
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 2);
                }
            }
        },
        yAxis: {
            labels: {
                formatter: function () {
                    return prefixConversion(this.value, 2);
                }
            },
            title: { enabled: true, text: params[2] }
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[4],
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
                    events: {
                        click: function (event) {
                            DQMClickChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchRmaChangeLimitData(...params) {
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
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            if (value.serialNumber.match(params[1])) {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            if (value.serialNumber.match(params[1])) {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                if (value.serialNumber.match(params[1])) {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
        }
        else {
            if (value.serialNumber.match(params[1])) {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
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
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, "isLimitChange": true });
                        }
                    }
                }
            }
            if (index == 1) {
                if (index + 1 < params[0].data.length) {
                    if (!(value.upperLimit.match(params[0].data[index + 1].upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, "isLimitChange": true });
                        }
                    } else if (!(params[0].data[index - 1].upperLimit.match(value.upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    }
                }
            }

            if (index + 2 < params[0].data.length && index - 2 >= 0) {      //DQMChannel.postMessage(index);
                if ((!(value.upperLimit.match(params[0].data[index - 1].upperLimit))) || (!(value.upperLimit.match(params[0].data[index + 1].upperLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    limitChangeData.push({ x: new Date(params[0].data[index - 2].timestamp).getTime(), y: Number(params[0].data[index - 2].upperLimit), "dataObj": params[0].data[index - 2], "isLimitChange": true });
                    limitChangeData.push({ x: new Date(params[0].data[index + 2].timestamp).getTime(), y: Number(params[0].data[index + 2].upperLimit), "dataObj": params[0].data[index + 2], "isLimitChange": true });
                } else if ((!(params[0].data[index - 2].upperLimit.match(params[0].data[index - 1].upperLimit))) || (!(params[0].data[index + 1].upperLimit.match(params[0].data[index + 2].upperLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, "isLimitChange": true });
                }
            }
            if (index == params[0].data.length - 1) {
                if (index - 1 > params[0].data.length) {
                    if ((value.upperLimit != params[0].data[index - 1].upperLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index - 2 > params[0].data.length) {
                        if (!(params[0].data[index - 1].upperLimit.match(params[0].data[index - 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, "isLimitChange": true });
                        }
                    }
                }
            }
            if (index == params[0].data.length - 2) {
                if (index - 2 < params[0].data.length) {
                    if (!(value.upperLimit.match(params[0].data[index - 1].upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index - 2 < params[0].data.length) {
                        if (!(params[0].data[index - 1].upperLimit.match(params[0].data[index - 2].upperLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, "isLimitChange": true });
                        }
                    } else if (!(params[0].data[index - 1].upperLimit.match(value.upperLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    }
                }
            }
        }
        if (value.lowerLimit != null && value.lowerLimit.length > 0) {
            lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });
            if (index == 0) {
                if (index + 1 < params[0].data.length) {
                    if ((value.lowerLimit != params[0].data[index + 1].lowerLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, "isLimitChange": true });
                        }
                    }
                }
            }
            if (index == 1) {
                if (index + 1 < params[0].data.length) {
                    if (!(value.lowerLimit.match(params[0].data[index + 1].lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index + 2 < params[0].data.length) {
                        if (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, "isLimitChange": true });
                        }
                    } else if (!(params[0].data[index - 1].lowerLimit.match(value.lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    }
                }
            }

            if (index + 2 < params[0].data.length && index - 2 >= 0) {
                if ((!(value.lowerLimit.match(params[0].data[index - 1].lowerLimit))) || (!(value.lowerLimit.match(params[0].data[index + 1].lowerLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    limitChangeData.push({ x: new Date(params[0].data[index - 2].timestamp).getTime(), y: Number(params[0].data[index - 2].lowerLimit), "dataObj": params[0].data[index - 2], "isLimitChange": true });
                    limitChangeData.push({ x: new Date(params[0].data[index + 2].timestamp).getTime(), y: Number(params[0].data[index + 2].lowerLimit), "dataObj": params[0].data[index + 2], "isLimitChange": true });
                } else if ((!(params[0].data[index - 2].lowerLimit.match(params[0].data[index - 1].lowerLimit))) || (!(params[0].data[index + 1].lowerLimit.match(params[0].data[index + 2].lowerLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, "isLimitChange": true });
                }
            }
            if (index == params[0].data.length - 1) {
                if (index - 1 > params[0].data.length) {
                    if ((value.lowerLimit != params[0].data[index - 1].lowerLimit)) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index - 2 > params[0].data.length) {
                        if (!(params[0].data[index - 1].lowerLimit.match(params[0].data[index - 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, "isLimitChange": true });
                        }
                    }
                }
            }
            if (index == params[0].data.length - 2) {
                if (index - 2 < params[0].data.length) {
                    if (!(value.lowerLimit.match(params[0].data[index - 1].lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    } else if (index - 2 < params[0].data.length) {
                        if (!(params[0].data[index - 1].lowerLimit.match(params[0].data[index - 2].lowerLimit))) {
                            limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, "isLimitChange": true });
                        }
                    } else if (!(params[0].data[index - 1].lowerLimit.match(value.lowerLimit))) {
                        limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 }, "isLimitChange": true });
                    }
                }
            }
        }
        index++;
    });

    seriesData.push({ name: params[3], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[7], data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[8], data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[9], data: limitChangeData, color: 'rgb(245,215,69)', marker: { radius: 2, symbol: 'circle' } });

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
            type: "datetime",
        },
        yAxis: {
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
            text: params[2],
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
                            var result = {};
                            if (event.point.isLimitChange == null || event.point.isLimitChange == undefined) {
                                result = { "isLimiChange": false, "changeLimitDataDTO": event.point.dataObj };
                            }
                            else {
                                result = { "isLimiChange": true, "changeLimitDataDTO": event.point.dataObj };
                            }
                            DQMRmaClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchCaseHistoryChangeLimitData(...params) {
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
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            if (value.serialNumber.match(params[1])) {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
            }
            else {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            if (value.serialNumber.match(params[1])) {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
            }
            else {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
                }
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });

            }
        }
        else {
            if (value.serialNumber.match(params[1])) {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
        }

        if (value.lowerLimit != null && value.lowerLimit.length > 0) {

            lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value });

        }
        if (value.upperLimit != null && value.upperLimit.length > 0) {
            upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.upperLimit), "dataObj": value });
        }
        if (value.upperLimit != null && value.upperLimit.length > 0) {
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

                    limitChangeData.push({ x: new Date(params[0].data[index - 1].timestamp).getTime(), y: Number(params[0].data[index - 1].upperLimit), "dataObj": params[0].data[index - 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index + 1].timestamp).getTime(), y: Number(params[0].data[index + 1].upperLimit), "dataObj": params[0].data[index + 2] });
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

            if (index + 2 < params[0].data.length && index - 2 >= 0) {      //DQMChannel.postMessage(index);
                if ((!(value.lowerLimit.match(params[0].data[index - 1].lowerLimit))) || (!(value.lowerLimit.match(params[0].data[index + 1].lowerLimit)))) {
                    limitChangeData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.lowerLimit), "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 5 } });
                    limitChangeData.push({ x: new Date(params[0].data[index - 2].timestamp).getTime(), y: Number(params[0].data[index - 2].lowerLimit), "dataObj": params[0].data[index - 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index + 2].timestamp).getTime(), y: Number(params[0].data[index + 2].lowerLimit), "dataObj": params[0].data[index + 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index - 1].timestamp).getTime(), y: Number(params[0].data[index - 1].lowerLimit), "dataObj": params[0].data[index - 2] });
                    limitChangeData.push({ x: new Date(params[0].data[index + 1].timestamp).getTime(), y: Number(params[0].data[index + 1].lowerLimit), "dataObj": params[0].data[index + 2] });
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
    seriesData.push({ name: params[3], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[7], data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[8], data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[9], data: limitChangeData, color: 'rgb(245,215,69)', marker: { radius: 2, symbol: 'circle' } });
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'scatter',
            spacingLeft: 0,
            spacingRight: 0,
            spacingBottom: 40,
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
                    this.series[6].legendSymbol.attr({
                        x: 0,
                        y: 7,
                        width: 10,
                        height: 10,
                    });
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
                    color: 'rgba(177, 177, 177, 0.4)'
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
            text: params[2]
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
                    events: {
                        click: function (event) {
                            DQMAnalogCpkTestResultChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchRmaFailureComponentData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var seriesData = [];

    params[0].data.forEach(function (value) {
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            if (value.serialNumber.match(params[1])) {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            if (value.serialNumber.match(params[1])) {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                if (value.serialNumber.match(params[1])) {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
                if (value.serialNumber.match(params[1])) {
                    falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }

            }
            else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else {
                if (value.serialNumber.match(params[1])) {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: 0, "dataObj": value });
                }
            }
        }
        else {
            if (value.serialNumber.match(params[1])) {
                failData.push({ x: new Date(value.timestamp).getTime(), y: 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: 0, "dataObj": value });
            }
        }

        lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: value.lowerLimit != null && value.lowerLimit.length > 0 ? Number(value.lowerLimit) : 0, "dataObj": value });
        upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: value.upperLimit != null && value.upperLimit.length > 0 ? Number(value.upperLimit) : 0, "dataObj": value });

    });

    seriesData.push({ name: params[7], data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[8], data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[3], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[4], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });

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
                    });
                }
            }
        },
        xAxis: {
            type: "datetime",
        },
        yAxis: {
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
            text: params[2],
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
                            DQMClickChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}


function fetchPATChartData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var limitChangeData = [];
    var seriesData = [];
    // var paul = params[2];
    // var pall = params[1];
    var index = 0;
    var centerarr = [];
    var patlowerarr = [];
    var patupperarr = [];
    params[0].data.forEach(function (value) {
        var paul = params[2];
        var pall = params[1];
        if (index == 0) {
            patlowerarr.push({ x: new Date(value.timestamp).getTime(), y: Number(pall), "dataObj": value, });
            patupperarr.push({ x: new Date(value.timestamp).getTime(), y: Number(paul), "dataObj": value, });
        } else if (index == (params[0].data.length - 1)) {
            patlowerarr.push({ x: new Date(value.timestamp).getTime(), y: Number(pall), "dataObj": value, });
            patupperarr.push({ x: new Date(value.timestamp).getTime(), y: Number(paul), "dataObj": value, });
        } else {
            centerarr.push({ x: new Date(value.timestamp).getTime(), y: null });
        }

        index++;

        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            if (value.serialNumber.match(params[1])) {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            if (value.serialNumber.match(params[1])) {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                if (value.serialNumber.match(params[1])) {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    passData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
                if (value.serialNumber.match(params[1])) {
                    falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }

            }
            else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
                if (value.serialNumber.match(params[1])) {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
            else {
                if (value.serialNumber.match(params[1])) {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
                }
                else {
                    failData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
                }
            }
        }
        else {
            if (value.serialNumber.match(params[1])) {
                failData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value, marker: { lineColor: 'rgba(245,215,69, 0.5)', lineWidth: 10 } });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
        }

        lowerLimitData.push({ x: new Date(value.timestamp).getTime(), y: value.lowerLimit != null && value.lowerLimit.length > 0 ? Number(value.lowerLimit) : 0, "dataObj": value });
        upperLimitData.push({ x: new Date(value.timestamp).getTime(), y: value.upperLimit != null && value.upperLimit.length > 0 ? Number(value.upperLimit) : 0, "dataObj": value });

    });
    const patData = [...patupperarr, ...centerarr, ...patlowerarr];
    const limit = [...lowerLimitData, ...upperLimitData];
    //  DQMAnalogCpkTestResultChannel.postMessage(patData);
    seriesData.push({ name: params[8], data: limit, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    // seriesData.push({ name: "Upper Limit", data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[6], data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[7], data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: params[4], data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[5], data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: params[9], data: patData, color: 'rgba(0, 218, 240, 1)', lineWidth: 2, marker: { radius: 2, symbol: 'circle' } });

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
            type: "datetime",
        },
        yAxis: {
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
            text: params[3]
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
                    events: {
                        click: function (event) {
                            DQMAnalogCpkTestResultChannel.postMessage(JSON.stringify(event.point.dataObj));
                        }
                    }
                }
            }
        },
        series: seriesData,
    });
}

function fetchComparationTestResultData(...params) {
    var passData = [];
    var falseFailureData = [];
    var anomalyData = [];
    var lowerLimitData = [];
    var upperLimitData = [];
    var failData = [];
    var seriesData = [];

    params[0].forEach(function (value) {
        if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
            falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
            anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
        }
        else if (value.status != null && value.status.length > 0) {
            if (value.status === "Anomaly") {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
            else if (value.status.includes("PASS") || value.status.includes("Pass") || value.status.includes("pass")) {
                passData.push({ x: new Date(value.timestamp).getTime(), y: Number(value.measured), "dataObj": value });
            }
            else if (value.isFalseFailure != null && value.isFalseFailure.length > 0 && value.isFalseFailure === "true") {
                falseFailureData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
            else if (value.isAnomaly != null && value.isAnomaly.length > 0 && value.isAnomaly === "true") {
                anomalyData.push({ x: new Date(value.timestamp).getTime(), y: value.measured != null && value.measured.length > 0 ? Number(value.measured) : 0, "dataObj": value });
            }
            else {
                failData.push({ x: new Date(value.timestamp).getTime(), y: 0, "dataObj": value });
            }
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

    seriesData.push({ name: "Pass", data: passData, color: 'rgba(115, 211, 44, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: "Fail", data: failData, color: 'rgba(227, 2, 42, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: "Anomaly", data: anomalyData, color: 'rgba(255, 107, 187, 0.5)', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: "False Failure", data: falseFailureData, color: 'rgba(255, 160, 122, 0.5)', marker: { radius: 4, symbol: 'triangle-down' } });
    seriesData.push({ name: "Lower Limit", data: lowerLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });
    seriesData.push({ name: "Upper Limit", data: upperLimitData, color: '#FFF', marker: { radius: 2, symbol: 'circle' } });

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
            type: "datetime",
        },
        yAxis: {
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
            text: 'Timestamp/Measured Value',
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
                    events: {
                        click: function (event) {
                            DQMResultClickChannel.postMessage(JSON.stringify(event.point.dataObj));
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

function exportImage() {
    if (chart1 != undefined) {
        var svg = chart1.getSVG();
        DQMExportImageChannel.postMessage(svg);
        // DQMExportImageChannel.postMessage('############ exportImage');
    }
    // if ( probeHeatMap != undefined) {
    //     var svg = probeHeatMap.getSVG();

    //     DQMExportImageChannel.postMessage(svg);
    // }
    DQMExportImageChannel.postMessage('############ exportImage');


}


function exportSummaryImage() {
    var allSVG = '';
    var title = '';
    if (chart1 != undefined) {
        allSVG = allSVG + chart1.getSVG();
        title = 'Failure'
    }
    if (chart2 != undefined) {
        DQMExportImageChannel.postMessage('@@@');
        allSVG = allSVG + chart2.getSVG();
        title = 'First Pass Yield'
    }
    if (chart3 != undefined) {
        DQMExportImageChannel.postMessage('@@@');
        allSVG = allSVG + chart3.getSVG();
        title = 'Yield'
    }
    if (chart4 != undefined) {
        DQMExportImageChannel.postMessage('@@@');
        allSVG = allSVG + chart4.getSVG();
        title = 'Volume'
    }

    // if ( probeHeatMap != undefined) {
    //     var svg = probeHeatMap.getSVG();

    //     DQMExportImageChannel.postMessage(svg);
    // }
    DQMExportImageChannel.postMessage(allSVG);




}

function exportSummaryPDF() {
    var allSVG = '';
    if (chart1 != undefined) {
        allSVG = chart1.getSVG();
    }
    if (chart2 != undefined) {
        allSVG = chart2.getSVG();
    }
    if (chart3 != undefined) {
        allSVG = chart3.getSVG();
    }
    if (chart4 != undefined) {
        allSVG = chart4.getSVG();
    }

    // if ( probeHeatMap != undefined) {
    //     var svg = probeHeatMap.getSVG();

    //     DQMExportImageChannel.postMessage(svg);
    // }
    DQMExportImageChannel.postMessage(allSVG);



}

function exportPDF() {
    if (chart1 != null && chart1 != undefined) {
        DQMExportPDFChannel.postMessage(chart1.getSVG());
    }
}

function probeFinder(...params) {
    // alert('test');
    // DQMProdeFinderChannel.postMessage(params[0][0]);
    // alert(value.x + "|" +  value.y +'|' +  value.value);
    var seriesData = [];


    var fixtureMaps = params[0];

    var fixtureOutlineDTOs = params[1];
    var maxValue = 0;
    var fixtureLayout = params[2];
    // DQMProdeFinderChannel.postMessage(fixtureLayout[3600]);

    var ratio = fixtureOutlineDTOs[0]['ratio'];
    var ratioBased = ratio.split(":");
    var xRatio = ratioBased[0];
    var yRatio = ratioBased[1];
    var OutlineData = [];
    var DotMapData = [];
    var LayoutDotData = [];
    var gheight = 100;
    var colorAxis = [];
    if (yRatio < 1 || xRatio < 1) {
        if (yRatio < 1) {
            gheight = ((yRatio / xRatio) * 100).toFixed(0);
        }
        else {
            gheight = ((xRatio / yRatio) * 100).toFixed(0);
        }
    }

    if (params[3] == 'analogCPK') {
        colorAxis = [
            [0, 'rgb(205, 0,0)'],
            [0.125, 'rgb(255, 0,0)'],
            [0.25, 'rgb(255, 159,0)'],
            [0.375, 'rgb(255, 255,0)'],
            [0.5, 'rgb(175, 255,79)'],
            [0.625, 'rgb(175, 255,79)'],
            [0.75, 'rgb(0, 239,255)'],
            [0.875, 'rgb(0,143,255)'],
            [1, 'rgb(0,0,239)'],
        ];
    } else {
        colorAxis = [
            [0, 'rgb(0,0,239)'],
            [0.125, 'rgb(0,143,255)'],
            [0.25, 'rgb(0, 239,255)'],
            [0.375, 'rgb(63,255,191)'],
            [0.5, 'rgb(175, 255,79)'],
            [0.625, 'rgb(255, 255,0)'],
            [0.75, 'rgb(255, 159,0)'],
            [0.875, 'rgb(255, 0,0)'],
            [1, 'rgb(205, 0,0)'],
        ];
    }
    // AlertProdeFinderChannel.postMessage('here');
    // AlertProdeFinderChannel.postMessage(testName);
    //  DQMProdeFinderChannel.postMessage('correct');

    fixtureLayout.forEach(function (data) {
        LayoutDotData.push({ x: Number(data.x), y: Number(data.y), 'dataObj': data });
    });
    //  DQMProdeFinderChannel.postMessage(LayoutDotData[0]);

    fixtureOutlineDTOs[0]['xy'].forEach(function (value) {
        OutlineData.push({ x: parseInt(value[0]), y: parseInt(value[1]) });
    });

    fixtureMaps.forEach(function (data) {
        DotMapData.push({ x: Number(data.x), y: Number(data.y), 'dataObj': data, name: data.node, "colorValue": data.value });
        if (maxValue < data.value) {
            maxValue = data.value;
        }
    });

    if (maxValue == 0) {
        maxValue = 75000;
    }

    chart1 = Highcharts.chart('container', {

        chart: {
            type: 'heatmap',
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

            }
        },
        xAxis: {
            visible: false,

        },
        yAxis: {
            visible: false,
        },
        credits: {
            enabled: false,
            position: {
                align: 'center',
                x: 0
            },
            text: 'Probe Finder',
        },
        colorAxis: {
            min: 0,
            max: (maxValue),

            stops: (colorAxis)
        },
        legend: {
            layout: 'horizontal',
            marginTop: 200,
            align: 'center',
            verticalAlign: 'top',
            itemStyle: {
                color: 'rgb(255,0,0)',

            },
        },
        tooltip: {
            enabled: false
        },
        plotOptions: {

            scatter: {
                turboThreshold: 0,
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {

                }

            },

            series: {
                turboThreshold: 0,
                cursor: 'pointer',
                point: {
                    events: {
                        click: function (event) {

                            DQMProdeFinderChannel.postMessage(JSON.stringify(event.point.dataObj));
                            // cpkDataResult = cpkData.find(row => (row.x === this.x));
                            // var result = { "date": this.dateStr, "cpkValue": cpkDataResult.y };
                            // AlertClickChannel.postMessage(JSON.stringify(result));
                        }
                    }
                }
            }
        },
        series: [
            {
                type: 'scatter',
                name: "OutLine",
                data: OutlineData,
                colorAxis: false,
                color: 'rgba(115, 211, 44, 0.9)',
                lineWidth: 2,
                marker: { radius: 0, enabled: false },
                showInLegend: false,
                enableMouseTracking: false
            },
            {

                type: 'scatter',
                name: "ProbeLayout",
                data: LayoutDotData,
                colorAxis: false,
                color: 'rgba(56, 183, 247,0.15)',
                marker: { radius: 2, symbol: 'circle' },
                showInLegend: false,
                enableMouseTracking: false
            },
            {

                type: 'scatter',
                name: "Probe",
                data: DotMapData,
                colorKey: 'colorValue',
                // data: [[-1000, -1001, 9],[1,1,0]],
                marker: { radius: 2, symbol: 'circle' },
                showInLegend: false,

            }
        ],
    });
}

function minValueForPercentage(val) {
    if (val > 25 && val < 50) {
        return 25;
    }
    else if (val > 50 && val < 75) {
        return 50;
    }
    else if (val > 75 && val < 100) {
        return 75;
    }
    else {
        return 0;
    }
}

function smallValueClickFunc(e) {
    let pointSelected;
    if (e.hasOwnProperty('point')) {
        pointSelected = e.point;
    } else {
        if (chart1 != null && chart1 != undefined) {
            const chart = chart1;
            // alert(chart.xAxis[0].toValue(e.chartY));
            const xPos = chart.xAxis[0].toValue(e.chartY);

            chart.series[0].points.forEach((point) => {
                if (xPos >= point.x - 0.5 && xPos <= point.x + 0.5) {
                    pointSelected = point;
                }
            });
        }
    }

    return pointSelected;
}