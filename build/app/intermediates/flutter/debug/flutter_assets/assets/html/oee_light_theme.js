$(function () {
    Highcharts.theme = {
        chart: {
            backgroundColor: 'rgba(255, 255, 255, 1)',
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
    OEEChannel.postMessage("");
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
function sortFunction(a, b) {
    var dateA = new Date(a.date).getTime();
    var dateB = new Date(b.date).getTime();
    return dateA > dateB ? 1 : -1;
}

function fetchDailyVolumeByEquipment(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    let listOfEq = [];
    //let listOfDate =[];
    var seriesData = [];

    var arr = params[0].data.sort(sortFunction);

    //alert(params[0].data[2].equipmentName);
    //OEEChannel.postMessage(arr);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }

    }
    for (let value of listOfEq) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                count.push([new Date(arr[x].date).getTime(), arr[x].count]);
            }
        }

        seriesData.push({ "data": count, "name": value });
        //OEEChannel.postMessage(seriesData);
    }
    //alert(seriesData);
    //print(seriesData);
    //OEEChannel.postMessage(seriesData);

    chart1 = Highcharts.chart('container', {

        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDailyVolumeByEquipmentChannel.postMessage('chart');
                }
            }
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
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

                        OEEDailyVolumeByEquipmentChannel.postMessage('dds');
                    }
                }
            },

        },
        series: seriesData
    });
}
function fetchDailyVolumeByEquipmentDetail(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    let listOfEq = [];
    //let listOfDate =[];
    var seriesData = [];
    var colors = [
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
    ];
    var arr = params[0].data.sort(sortFunction);

    //alert(params[0].data[2].equipmentName);
    //OEEChannel.postMessage(arr);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }

    }
    for (let value of listOfEq) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                count.push([new Date(arr[x].date).getTime(), arr[x].count]);
            }
        }

        seriesData.push({ "data": count, "name": value });
        //OEEChannel.postMessage(seriesData);
    }
    //alert(seriesData);
    //print(seriesData);
    //OEEChannel.postMessage(seriesData);

    chart1 = Highcharts.chart('container', {

        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
            events: {

            }
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,
            }, text: params[3],
        },
        tooltip: {
            enabled: false
        },
        legend: {
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

                        let selectedDate = event.point.x;
                        let data = [];
                        var count = 0;
                        // OEEClickChannel.postMessage('datsdasda');
                        //new Date(arr[x].date).getTime();
                        //OEEClickChannel.postMessage(event.point.x);

                        for (let x of arr) {
                            var index;
                            let date = new Date(x.date).getTime();
                            //  OEEClickChannel.postMessage(date)
                            if (date == selectedDate) {
                                index = listOfEq.indexOf(x.equipmentName);
                                data.push({ 'equipmentName': x.equipmentName, 'count': x.count, 'color': colors[index] });
                            }
                            count++;
                        }
                        var finalResult = { 'id': (event.point.x).toString(), 'data': data };

                        OEEClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: seriesData
    });
}



function fetchDailyVolumeByProject(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var colors = [
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
    ];
    let listOfProj = [];
    var seriesData = [];
    var arr = params[0].data.sort(sortFunction);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfProj.includes(arr[x].projectId)) {
            listOfProj.push(arr[x].projectId);
        }

    }
    for (let value of listOfProj) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].projectId) {
                count.push([new Date(arr[x].date).getTime(), arr[x].count]);
            }
        }
        seriesData.push({ "data": count, "name": value });
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDailyVolumeByProjectChannel.postMessage('chart');
                }
            }
        },        colors: [
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
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
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
                        OEEDailyVolumeByProjectChannel.postMessage('dds');
                    }
                }
            },
        },
        series: seriesData
    });
}
function fetchDailyVolumeByProjectDetail(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    let listOfProj = [];
    //let listOfDate =[];
    var seriesData = [];
    var colors = [
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
    ];
    var arr = params[0].data.sort(sortFunction);

    //alert(params[0].data[2].equipmentName);
    //OEEChannel.postMessage(arr);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfProj.includes(arr[x].projectId)) {
            listOfProj.push(arr[x].projectId);
        }

    }
    for (let value of listOfProj) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].projectId) {
                count.push([new Date(arr[x].date).getTime(), arr[x].count]);
            }
        }

        seriesData.push({ "data": count, "name": value });
        //OEEChannel.postMessage(seriesData);
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
            events: {
                click: function (event) {
                    //  DQMDailyVolumeChannel.postMessage('');
                }
            }
        },
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
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
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
        legend: {
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
                     click:  function (event) {

                        let selectedDate = event.point.x;
                        let data = [];
                        var count = 0;
                       //  OEEClickChannel.postMessage(selectedDate);
                        //new Date(arr[x].date).getTime();
                        //OEEClickChannel.postMessage(event.point.x);

                        for (let x of arr) {
                            var index;
                            let date = new Date(x.date).getTime();
                            
                            if (date == selectedDate) {
                                index = listOfProj.indexOf(x.projectId.toString());
                             //   OEEClickChannel.postMessage(listOfProj);
                                
                          
                                data.push({ 'equipmentName': x.projectId, 'count': x.count, 'color': colors[index] });
                            }
                            count++;
                          //   OEEClickChannel.postMessage(data)
                        }
                        var finalResult = { 'id': (event.point.x).toString(), 'data': data };

                        OEEClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                }
            },
        },
        series: seriesData
    });
}



function fetchDailyOEEScore(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    let listOfEq = [];
    //let listOfDate =[];
    var seriesData = [];

    var arr = params[0].data.sort(sortFunction);

    //alert(params[0].data[2].equipmentName);
    //OEEChannel.postMessage(arr);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }

    }
    for (let value of listOfEq) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                count.push([new Date(arr[x].date).getTime(), arr[x].oee]);
            }
        }

        seriesData.push({ "data": count, "name": value });
        //OEEChannel.postMessage(seriesData);
    }

    chart1 = Highcharts.chart('container', {
        chart: {

            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDailyScoreOEE.postMessage('');
                }
            }
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            line: {
                marker: {
                    radius: 3,
                    symbol: 'circle',
                },
                allowPointSelect: false,
                stickyTracking: false,
                events: {
                    click: function (event) {

                        OEEDailyScoreOEE.postMessage('dds');
                    }
                }
            }
            ,
            series: {
                enableMouseTracking: false,
                label: {
                    connectorAllowed: false
                },
                pointStart: startDate

            }
        },
        series: seriesData
    });
}
function fetchDailyOEEScoreDetail(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    let listOfEq = [];
    //let listOfDate =[];
    var seriesData = [];
    var colors = [
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
    ];
    var arr = params[0].data.sort(sortFunction);

    //alert(params[0].data[2].equipmentName);
    //OEEChannel.postMessage(arr);
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }

    }
    for (let value of listOfEq) {
        var count = [];
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                count.push([new Date(arr[x].date).getTime(), arr[x].oee]);
            }
        }

        seriesData.push({ "data": count, "name": value });
        //OEEChannel.postMessage(seriesData);
    }

    chart1 = Highcharts.chart('container', {
        chart: {

            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEClickChannel.postMessage('');
                }
            }
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
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
        legend: {
            enabled: false
        },
        plotOptions: {
            line: {
                marker: {
                    radius: 3,
                    symbol: 'circle',
                },
                events: {
                    click: function (event) {

                        // OEEClickChannel.postMessage(event.point.x);
                        var selectedDate = event.point.x;
                        var count = 0;
                        var data = [];
                        for (let x of arr) {
                            var index;
                            let date = new Date(x.date).getTime();
                            if (date == selectedDate) {
                                index = listOfEq.indexOf(x.equipmentName);
                                data.push({ 'equipmentName': x.equipmentName, 'oee': x.oee.toFixed(2).toString(), 'color': colors[index] });
                            }
                            count++;
                        }
                        var finalResult = { 'id': (event.point.x).toString(), 'data': data };

                        OEEClickChannel.postMessage(JSON.stringify(finalResult));
                    }
                },
            },
            series: {
                cursor: 'pointer',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                point: {

                }
            },

        },
        series: seriesData
    });
}


function fetchVolumeByEquipmentData(...params) {
    var seriesData = [];
    var listOfEq = [];

    var arr = params[0].data;
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }
    }
    for (let value of listOfEq) {
        var count = [];
        var index;
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                index = listOfEq.indexOf(arr[x].equipmentName)
                count[index] = arr[x].count;
            } else {
                count.push(0)
            }
        }


        seriesData.push({ "data": count.slice(0, listOfEq.length), "name": value });

    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            //spacingLeft: 10,
            //spacingRight: 10,
            events: {
                click: function (event) {
                    OEEVolumeByEquipmentChannel.postMessage('');
                }
            }
        },
        xAxis: {
            categories: listOfEq,

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
        legend: {
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
                        OEEVolumeByEquipmentChannel.postMessage('');
                    }
                }
            },
            // series: {
            //     pointWidth: 50,
            // }
        },
        series: seriesData
    });
}
function fetchVolumeByEquipmentDataDetail(...params) {
    var seriesData = [];
    var listOfEq = [];
    var colors = [
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
    ];
    var arr = params[0].data;
    for (let x = 0; x < arr.length; x++) {
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }
    }
    for (let value of listOfEq) {
        var count = [];
        var index;
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                index = listOfEq.indexOf(arr[x].equipmentName)
                count[index] = arr[x].count;
            } else {
                count.push(0)
            }
        }


        seriesData.push({ "data": count.slice(0, listOfEq.length), "name": value });

    }

    var chartHeight = 350;
    var xMax = 6;
    if (listOfEq.length > 5) {
        chartHeight = 600;
    }
    else {
        xMax = listOfEq.length - 1;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: chartHeight,
            spacingLeft: 0,
            spacingRight: 0,
            zoomType: 'xy',
            spacingBottom: 30,
            events: {
                click: function (event) {
                    var data = seriesData[smallValueClickFunc(event).x].data[smallValueClickFunc(event).x];
                    var finalResult = { 'equipmentName': seriesData[smallValueClickFunc(event).x].name, 'count': data, 'color': colors[smallValueClickFunc(event).x] };
                    OEEClickChannel.postMessage(JSON.stringify(finalResult));
                }
            }
        },
        xAxis: {
            categories: listOfEq,
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
                    color: 'rgba(0, 0, 0, 1)',
                    fontSize: '11px',
                },
                formatter: function (event) {
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
                x: 0

            },
            text: params[3],
        },
        tooltip: {
            enabled: false
        },
        legend: {
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
                        //OEEClickChannel.postMessage('asdas');
                        var data = seriesData[event.point.x].data[event.point.x];
                        //OEEClickChannel.postMessage('dddddddd');
                        // OEEClickChannel.postMessage(seriesData);
                        var finalResult = { 'equipmentName': seriesData[event.point.x].name, 'count': data, 'color': colors[event.point.x] };
                        OEEClickChannel.postMessage(JSON.stringify(finalResult));
                        // OEEClickChannel.postMessage(seriesData);
                    },
                },
            },
            // series: {
            //     pointWidth: 50,
            // }
        },
        series: seriesData
    });
}



function fetchVolumeByProjectData(...params) {
    var seriesData = [];

    var listOfProj = [];
    var listOfEq = [];
    var arr = params[0].data;
    for (let x = 0; x < arr.length; x++) {
        if (!listOfProj.includes(arr[x].projectId)) {
            var newStr = '';
            if (arr[x].projectId.includes('<')) {
                const myArray = arr[x].projectId.split("<");
                newStr = myArray[0] + "&lt;" + myArray[1];
            }
            else {
                newStr = arr[x].projectId;
            }
            listOfProj.push(newStr);
        }
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }
    }
    for (let value of listOfEq) {
        var count = [];
        var index;
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                index = listOfProj.indexOf(arr[x].projectId)
                count[index] = arr[x].count;
            } else {
                count.push(0)
            }
        }


        seriesData.push({ "data": count.slice(0, listOfProj.length), "name": value });

    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            //spacingLeft: 10,
            //spacingRight: 10,
            events: {
                click: function (event) {
                    OEEVolumeByProjectChannel.postMessage('');
                }
            }
        },
        xAxis: {
            categories: listOfProj,
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
        legend: {
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
                        OEEVolumeByProjectChannel.postMessage('');
                    }
                }
            },
            series: {
                pointWidth: 50,
            }
        },
        series: seriesData
    });
}
function fetchVolumeByProjectDataDetail(...params) {
    var seriesData = [];
    var projectNames = [];
    var listOfProj = [];
    var listOfEq = [];
    var colors = [
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
    ];
    var arr = params[0].data;
    for (let x = 0; x < arr.length; x++) {
        if (!listOfProj.includes(arr[x].projectId)) {
            listOfProj.push(arr[x].projectId);
        }
        if (!listOfEq.includes(arr[x].equipmentName)) {
            listOfEq.push(arr[x].equipmentName);
        }
    }
    for (let value of listOfEq) {
        var count = [];
        var index;
        for (let x = 0; x < arr.length; x++) {
            if (value == arr[x].equipmentName) {
                index = listOfProj.indexOf(arr[x].projectId)
                count[index] = arr[x].count;
            } else {
                count.push(0)
            }
        }


        seriesData.push({ "data": count.slice(0, listOfProj.length), "name": value });

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
                    var x = listOfProj[smallValueClickFunc(event).x];
                    var data = [];
                    var count = 0;

                    for (let g of seriesData) {
                        if (g.data[smallValueClickFunc(event).x] != 0) {
                            data.push({ 'equipmentName': g.name, 'count': g.data[smallValueClickFunc(event).x], 'color': colors[count] });
                        }
                        count += 1;
                    }
                    var finalResult = { 'id': x, 'data': data };
                    OEEClickChannel.postMessage(JSON.stringify(finalResult));
                }
            }
        },
        xAxis: {
            categories: listOfProj,
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
                formatter: function (event) {
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
        legend: {
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
                        var x = listOfProj[event.point.x];
                        //  OEEClickChannel.postMessage(series.bar.data);
                        var data = [];
                        var count = 0;


                        for (let g of seriesData) {
                            if (g.data[event.point.x] != 0) {
                                data.push({ 'equipmentName': g.name, 'count': g.data[event.point.x], 'color': colors[count] });
                            }
                            count += 1;
                        }
                        var finalResult = { 'id': x, 'data': data };
                        // OEEClickChannel.postMessage();
                        //  OEEClickChannel.postMessage(x);
                        // OEEChannel.postMessage(event.point.color);
                        OEEClickChannel.postMessage(JSON.stringify(finalResult));
                    },
                }
            },

        },
        series: seriesData,

    });
}


function fetchDailyUtilisationbyAllEquipment(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var available = [];
    var utilisation = [];
    var plannedDT = [];
    var downTime = [];
    var arr = params[0].data.sort(sortFunction);
    arr.map(function (row) {
        available.push([new Date(row.date).getTime(), row.availableTime]);
        utilisation.push([new Date(row.date).getTime(), row.utilizationTime]);
        plannedDT.push([new Date(row.date).getTime(), row.plannedDownTime]);
        downTime.push([new Date(row.date).getTime(), row.downTime]);
    });


    chart1 = Highcharts.chart('container', {
        chart: {

            spacingLeft: 10,
            spacingRight: 10,


            events: {
                click: function (event) {
                    OEEDailyUtilisationbyAllEquipmentChannel.postMessage('');
                }
            },

        },
        xAxis: {

            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {

            width: '110%',
            x: -10,
            itemMarginBottom: 16,

            itemStyle: { "fontSize": '12px' },

            //borderColor: '#ffffff',
            //borderWidth:2,
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    }, click: function (event) {
                        OEEDailyUtilisationbyAllEquipmentChannel.postMessage('');
                    }

                },
            },
            series: {
                enableMouseTracking: false,
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    }, click: function (event) {
                        OEEDailyUtilisationbyAllEquipmentChannel.postMessage('');
                    }
                },
            },

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
                        OEEDailyUtilisationbyAllEquipmentChannel.postMessage('');
                    }
                }

            },
        },
        series: [{
            type: 'line',
            name: params[3],// "Available Time",
            data: available,
            color: '#72D12C'
        },
        {
            type: 'column',
            name: params[4],//"Utilisation Time",
            data: utilisation,
            color: '#25DBD9',
        },
        {
            type: 'column',
            name: params[6],//"Planned Down Time",
            data: plannedDT,
            color: '#F56A02'
        }, {
            type: 'column',
            name: params[5],//"Down Time",
            data: downTime,
            color: '#E30329'
        },]
    });
}

function fetchDailyUtilisationbyAllEquipmentDetail(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var available = [];
    var utilisation = [];
    var plannedDT = [];
    var downTime = [];
    var arr = params[0].data.sort(sortFunction);
    params[0].data.map(function (row) {
        available.push([new Date(row.date).getTime(), row.availableTime]);
        utilisation.push([new Date(row.date).getTime(), row.utilizationTime]);
        plannedDT.push([new Date(row.date).getTime(), row.plannedDownTime]);
        downTime.push([new Date(row.date).getTime(), row.downTime]);
    });
    //OEEClickChannel.postMessage("hello");

    chart1 = Highcharts.chart('container', {
        chart: {
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
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
        legend: {

            width: '110%',
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '12px' },

            //borderColor: '#ffffff',
            //borderWidth:2,
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {
                    click: function (event) {


                        var result;
                        for (let x = 0; x < arr.length; x++) {
                            var key = event.point.x;

                            if (key == (new Date(arr[x].date).getTime())) {
                                result = arr[x].date
                            }
                        }
                        OEEClickChannel.postMessage(result);
                    }
                },
            },
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
                        var result;
                        for (let x = 0; x < arr.length; x++) {
                            var key = event.point.x;

                            if (key == (new Date(arr[x].date).getTime())) {
                                result = arr[x].date
                            }
                        }
                        OEEClickChannel.postMessage(result);
                    }
                }

            },
        },
        series: [{
            type: 'line',
            name: params[3],// "Available Time",
            data: available,
            color: '#72D12C'
        },
        {
            type: 'column',
            name: params[4],//"Utilisation Time",
            data: utilisation,
            color: '#25DBD9',
        },
        {
            type: 'column',
            name: params[6],//"Planned Down Time",
            data: plannedDT,
            color: '#F56A02'
        }, {
            type: 'column',
            name: params[5],//"Down Time",
            data: downTime,
            color: '#E30329'
        },]
    });

}


function fetchSummaryUtilAndNonUtil(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var keys = Object.keys(params[0].data);

    var scheduleUtilTime = [];
    var scheduleNonUtilTime = [];
    var unscheduleUtilTime = [];
    var timeline = params[3];
    if (timeline == 'Date') {
        var categories = new Date(keys).getTime();
        for (let key of keys) {
            var json = params[0].data[key]

            scheduleUtilTime.push([new Date(key).getTime(), json.scheduledUtilizationTime]);
            scheduleNonUtilTime.push([new Date(key).getTime(), json.scheduledNonUtilizationTime]);
            unscheduleUtilTime.push([new Date(key).getTime(), json.unscheduledUtilizationTime]);
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    } else {
        var categories = keys;
        for (let key of keys) {
            var json = params[0].data[key]

            scheduleUtilTime.push([key, json.scheduledUtilizationTime]);
            scheduleNonUtilTime.push([key, json.scheduledNonUtilizationTime]);
            unscheduleUtilTime.push([key, json.unscheduledUtilizationTime]);
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    }


    //OEEChannel.postMessage("hello");

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDetailBreakdown.postMessage('');
                }
            }
        },
        xAxis: {
            categories: categories,
            type: 'datetime',
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false,
        },
        legend: {

            width: '110%',
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '12px' },

            //borderColor: '#ffffff',
            //borderWidth:2,
        },
        plotOptions: {
            series: {
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    }
                },
            },
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
                        OEESummaryUtilAndNonUtil.postMessage('');
                    }
                }

            },
        },
        series: [{
            name: params[4],//"Scheduled Non-Utilization Time",
            data: scheduleNonUtilTime,
            color: '#E30329'
        },
        {
            name: params[5],//"Scheduled Utilisation Time",
            data: scheduleUtilTime,
            color: '#72D12C',
        },
        {
            name: params[6],//"Unscheduled Utilisation Time",
            data: unscheduleUtilTime,
            color: '#D5B51D'
        }
        ]
    });

}

function fetchSummaryUtilAndNonUtilDetail(...params) {

    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var keys = Object.keys(params[0].data);

    var scheduleUtilTime = [];
    var scheduleNonUtilTime = [];
    var unscheduleUtilTime = [];
    var timeline = params[3];
    if (timeline == 'Date') {
        var categories = new Date(keys).getTime();
        for (let key of keys) {
            var json = params[0].data[key]

            scheduleUtilTime.push([new Date(key).getTime(), json.scheduledUtilizationTime]);
            scheduleNonUtilTime.push([new Date(key).getTime(), json.scheduledNonUtilizationTime]);
            unscheduleUtilTime.push([new Date(key).getTime(), json.unscheduledUtilizationTime]);
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    } else {
        var categories = keys;
        for (let key of keys) {
            var json = params[0].data[key]

            scheduleUtilTime.push([key, json.scheduledUtilizationTime]);
            scheduleNonUtilTime.push([key, json.scheduledNonUtilizationTime]);
            unscheduleUtilTime.push([key, json.unscheduledUtilizationTime]);
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    }


    //OEEChannel.postMessage("hello");

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            spacingBottom: 30,
            events: {
                click: function (event) {
                    OEEDetailBreakdown.postMessage('');
                }
            }
        },
        xAxis: {
            categories: categories,
            type: 'datetime',
        },
        yAxis: {
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,

            },
            text: (params[4])
        },
        tooltip: {
            enabled: false
        },
        legend: {

            width: '110%',
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '12px' },

            //borderColor: '#ffffff',
            //borderWidth:2,
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

                        if (timeline == 'Date') {
                            OEEClickChannel.postMessage(event.point.x);

                        } else {

                            OEEClickChannel.postMessage(keys[event.point.x]);
                        }
                    }
                }

            },
        },
        series: [{
            name: params[5],//"Scheduled Non-Utilization Time",
            data: scheduleNonUtilTime,
            color: '#E30329'
        },
        {
            name: params[6],//"Scheduled Utilisation Time",
            data: scheduleUtilTime,
            color: '#72D12C',
        },
        {
            name: params[7],//"Unscheduled Utilisation Time",
            data: unscheduleUtilTime,
            color: '#D5B51D'
        }
        ]
    });

}


function fetchdetailBreakdownforscedulesNonUtilTime(...params) {


    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var keys = Object.keys(params[0].data);

    var diagnosticMaintenance = [];
    var idle = [];
    var lostHeartbeat = [];
    var fixtureChange = [];
    var systemTilt = [];
    var timeline = params[3];
    if (timeline == 'Date') {
        var categories = new Date(keys).getTime();
        for (let key of keys) {
            for (let data of params[0].data[key]) {
                if (data.status == 'diagnostic maintenance') {
                    diagnosticMaintenance.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'idle') {
                    idle.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'lost heartbeat') {
                    lostHeartbeat.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'fixture change') {
                    fixtureChange.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'system tilt') {
                    systemTilt.push([new Date(key).getTime(), data.statusTime]);
                }
            }
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    } else {
        var categories = keys;

        for (let key of keys) {
            for (let data of params[0].data[key]) {
                if (data.status == 'diagnostic maintenance') {
                    diagnosticMaintenance.push([key, data.statusTime]);
                } else if (data.status == 'idle') {
                    idle.push([key, data.statusTime]);
                } else if (data.status == 'lost heartbeat') {
                    lostHeartbeat.push([key, data.statusTime]);
                } else if (data.status == 'fixture change') {
                    fixtureChange.push([key, data.statusTime]);
                } else if (data.status == 'system tilt') {
                    systemTilt.push([key, data.statusTime]);
                }
            }
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    };

    //OEEChannel.postMessage("hello");

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDetailBreakdown.postMessage('');
                }
            }
        },
        xAxis: {
            categories: categories,
            type: 'datetime',
        },
        yAxis: {
        },
        credits: {
            enabled: false,
        },
        tooltip: {
            enabled: false
        },
        legend: {

            width: '120%',
            x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '12px' },
            // itemdistance: 0,
            // borderColor: '#ffffff',
            // borderWidth:2,
        },
        plotOptions: {
            series: {
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    }
                },
            },
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
                        OEEDetailBreakdown.postMessage('');
                    }
                }

            },
        },
        series: [
            {
                name: params[4],//"Diagnostic Maintenance",
                data: diagnosticMaintenance,

            }, {
                name: params[5],//"Idle",
                data: idle,

            },
            {
                name: params[6],//"Lost Heartbeat",
                data: lostHeartbeat,

            },

            {
                name: params[7],//"Fixture Change",
                data: fixtureChange,

            },
            {
                name: params[8],//"System Tilt",
                data: systemTilt,
            },
        ]
    });

}

function fetchdetailBreakdownforscedulesNonUtilTimeData(...params) {


    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var keys = Object.keys(params[0].data);

    var diagnosticMaintenance = [];
    var idle = [];
    var lostHeartbeat = [];
    var fixtureChange = [];
    var systemTilt = [];
    var timeline = params[3];
    if (timeline == 'Date') {
        var categories = new Date(keys).getTime();
        for (let key of keys) {
            for (let data of params[0].data[key]) {
                if (data.status == 'diagnostic maintenance') {
                    diagnosticMaintenance.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'idle') {
                    idle.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'lost heartbeat') {
                    lostHeartbeat.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'fixture change') {
                    fixtureChange.push([new Date(key).getTime(), data.statusTime]);
                } else if (data.status == 'system tilt') {
                    systemTilt.push([new Date(key).getTime(), data.statusTime]);
                }
            }
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    } else {
        var categories = keys;

        for (let key of keys) {
            for (let data of params[0].data[key]) {
                if (data.status == 'diagnostic maintenance') {
                    diagnosticMaintenance.push([key, data.statusTime]);
                } else if (data.status == 'idle') {
                    idle.push([key, data.statusTime]);
                } else if (data.status == 'lost heartbeat') {
                    lostHeartbeat.push([key, data.statusTime]);
                } else if (data.status == 'fixture change') {
                    fixtureChange.push([key, data.statusTime]);
                } else if (data.status == 'system tilt') {
                    systemTilt.push([key, data.statusTime]);
                }
            }
            //  OEEChannel.postMessage(new Date(key).getTime());
        };
    };

    //OEEChannel.postMessage("hello");

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,
            events: {
                click: function (event) {
                    OEEDetailBreakdown.postMessage('');
                }
            }
        },
        xAxis: {
            categories: categories,
            type: 'datetime',
        },
        yAxis: {
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0,

            },
            text: (params[4])
        },
        tooltip: {
            enabled: false
        },
        legend: {

            width: '120%',
            x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '12px' },
            // itemdistance: 0,
            // borderColor: '#ffffff',
            // borderWidth:2,
        },
        plotOptions: {
            series: {
                events: {
                    legendItemClick: function (e) {
                        e.preventDefault();
                    }
                },
            },
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
                      if (timeline == 'Date') {
                            OEEClickChannel.postMessage(event.point.x);

                        } else {

                            OEEClickChannel.postMessage(keys[event.point.x]);
                        }
                    }
                }

            },
        },
        series: [
            {
                name: params[5],//"Diagnostic Maintenance",
                data: diagnosticMaintenance,

            }, {
                name: params[6],//"Idle",
                data: idle,

            },
            {
                name: params[7],//"Lost Heartbeat",
                data: lostHeartbeat,

            },

            {
                name: params[8],//"Fixture Change",
                data: fixtureChange,

            },
            {
                name: params[9],//"System Tilt",
                data: systemTilt,
            },
        ]
    });

}


function fetchSiteDailyOEEInfo(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var arr = params[0].data.sort(sortFunction);

    var availability = [];
    var quality = [];
    var performance = [];
    var oee = [];
    for (let data of arr) {
        availability.push([new Date(data.date).getTime(), data.availability]);
        quality.push([new Date(data.date).getTime(), data.quality]);
        performance.push([new Date(data.date).getTime(), data.performance]);
        oee.push([new Date(data.date).getTime(), data.oee]);
    };


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[7],
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: true,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {

                    click: function (event) {
                        var selectedDate = event.point.x;
                        //OEEClickChannel.postMessage(selectedDate);
                        for (let data of arr) {
                            if (new Date(data.date).getTime() == selectedDate) {
                                let date = new Date(selectedDate);
                                let formattedDate = date.toLocaleString('sv');
                                var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                                break;
                            }
                        };
                        OEEClickChannel.postMessage(JSON.stringify(result));

                    },
                },
                series: {

                },

            },
        },
        series: [{
            name: params[3],//"Availability",
            data: availability,
            marker: {
                symbol: 'circle',
            }
        },
        {
            name: params[4],//"Quality",
            data: quality, marker: {
                symbol: 'circle',
            }
            //color: '#72D12C',
        },
        {
            name: params[5],// "Performance",
            data: performance, marker: {
                symbol: 'circle',
            }
            //           color: '#D5B51D'
        },
        {
            name: params[6],// "OEE",
            data: oee, marker: {
                symbol: 'circle',
            }
            //color: '#D5B51D'
        }
        ]
    });
}

function fetchEquipmentDailyOEEInfo(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);

    var arr = params[0].data.sort(sortFunction);

    var availability = [];
    var quality = [];
    var performance = [];
    var oee = [];
    for (let data of arr) {
        availability.push([new Date(data.date).getTime(), data.availability]);
        quality.push([new Date(data.date).getTime(), data.quality]);
        performance.push([new Date(data.date).getTime(), data.performance]);
        oee.push([new Date(data.date).getTime(), data.oee]);
    };


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: true,
            position: {
                align: 'center',
                x: 0
            },
            text: params[7],
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: true,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                events: {

                    click: function (event) {
                        var selectedDate = event.point.x;
                        //OEEClickChannel.postMessage(selectedDate);
                        for (let data of arr) {
                            if (new Date(data.date).getTime() == selectedDate) {
                                let date = new Date(selectedDate);
                                let formattedDate = date.toLocaleString('sv');
                                var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                                break;
                            }
                        };
                        OEEClickChannel.postMessage(JSON.stringify(result));

                    },
                },
                series: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        //OEEClickChannel.postMessage(selectedDate);
                        for (let data of arr) {
                            if (new Date(data.date).getTime() == selectedDate) {
                                let date = new Date(selectedDate);
                                let formattedDate = date.toLocaleString('sv');
                                var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                                break;
                            }
                        };
                        OEEClickChannel.postMessage(JSON.stringify(result));

                    },
                },

            },
        },
        series: [{
            name: params[3],//"Availability",
            data: availability,
            marker: {
                symbol: 'circle',
            }
        },
        {
            name: params[4],//"Quality",
            data: quality, marker: {
                symbol: 'circle',
            }
            //color: '#72D12C',
        },
        {
            name: params[5],// "Performance",
            data: performance, marker: {
                symbol: 'circle',
            }
            //           color: '#D5B51D'
        },
        {
            name: params[6],// "OEE",
            data: oee, marker: {
                symbol: 'circle',
            }
            //color: '#D5B51D'
        }
        ]
    });
}


//available
function fetchSummaryAvailableTime(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var availableTime = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime });
            }
        });

        if (!isValid) {
            availableTime.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },
        color: 'rgb(115, 211, 44)',
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },


            },
            series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');

                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        //         let date = new Date(selectedDate);
                        //         let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEAvailableTimeChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "Available Time",
                data: availableTime,
                //color:'rgb(0, 255, 255)'
                color: 'rgb(115, 211, 44)'
            },

            ]

    });
}

function fetchSummaryUtilTime(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var utilTime = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                utilTime.push({ x: new Date(value.date).getTime(), y: value.utilizationTime });
            }
        });

        if (!isValid) {
            utilTime.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,

        },
        color: 'rgb(0, 255, 255)',
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            column: {
                borderColor: 'transparent',
                states: {
                    inactive: {
                        opacity: 1
                    }
                },


            }, series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');

                        //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        //         let date = new Date(selectedDate);
                        //         let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEUtilTimeChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "Utilization Time",
                data: utilTime,
                color: 'rgb(0, 255, 255)'
            },

            ]

    });
}

function fetchSummaryPlannedDownTime(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var downTime = [];
    var plannedDownTime = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;

                plannedDownTime.push([new Date(value.date).getTime(), value.plannedDownTime]);
                downTime.push([new Date(value.date).getTime(), value.downTime]);

            }
        });


    });
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
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
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');

                        //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        //         let date = new Date(selectedDate);
                        //         let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEPlannedDTMChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: [
            {
                name: "Planned Down Time",
                data: plannedDownTime,
                color: '#F56A02'
            },
            {
                name: "Down Time",
                data: downTime,
                color: '#E30329'
            }
        ]

    });
}

function fetchSummaryAvailability(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var availability = [];
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                availability.push({ x: new Date(value.date).getTime(), y: value.availability });
            }
        });


    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'areaspline',
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
                    color: 'rgba(0, 0, 0, 1)',
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
            areaspline: {
                fillOpacity: 0.2

            },
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

                        }
                    }
                }
            }
        },
        series: [{
            name: "Availability",
            data: availability,
            color: "rgb(180, 226, 165)"
        }]
    });
}
//availabledetail
function fetchSummaryAvailableTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.availableTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryUtilTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.utilizationTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryPlannedDownTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.downTime + currentValue.plannedDownTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}
//performance
function fetchSummaryPerformanceRetestPassFailed(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var failedCount = [];
    var retestCount = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;

                failedCount.push([new Date(value.date).getTime(), value.failUtilizationTime]);
                retestCount.push([new Date(value.date).getTime(), value.retestUtilizationTime]);

            }
        });


    });
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
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
            }, series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEPerformanceRetestChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: [
            {
                name: "Failed Count",
                data: failedCount,
                color: '#E90029'
            },
            {
                name: "Retest Count",
                data: retestCount,
                color: '#E76C27'
            }
        ]

    });
}

function fetchSummaryPerformanceFirstPass(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var utilTime = [];

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                utilTime.push({ x: new Date(value.date).getTime(), y: value.firstPassUtilizationTime });
            }
        });

        if (!isValid) {
            utilTime.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {

            column: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
                borderColor: 'transparent',
            },
            series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEPerformanceFirstPassChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "First Pass",
                data: utilTime,
                color: 'rgb(115, 211, 44)'
            },
            ]
    });
}

function fetchSummaryPerformanceIdealCycle(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var idealcycle = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                // var fy = ((value.firstPassCount + value.retestCount) / (value.firstPassCount + value.retestCount + value.failedCount)) * 100;
                idealcycle.push({ x: new Date(value.date).getTime(), y: value.idealCycleTime });
            }
        });

        if (!isValid) {
            idealcycle.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },

        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },


            },
            series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEPerformanceIdealChannel.postMessage(formattedDate);


                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "Ideal Cycle",
                data: idealcycle,
                color: 'rgb(5, 160, 167)'
            },

            ]

    });
}

function fetchSummaryPerformanceMetric(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var availability = [];
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                availability.push({ x: new Date(value.date).getTime(), y: value.performance });
            }
        });


    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'areaspline',
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
                    color: 'rgba(0, 0, 0, 1)',
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
            areaspline: {
                fillOpacity: 0.2
            },
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

                        }
                    }
                }
            }
        },
        series: [{
            name: "Availability",
            data: availability,
            color: "rgb(180, 226, 165)"
        }]
    });
}
//performancedetail
function fetchSummaryPerformanceRetestPassFailedDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.retestUtilizationTime + currentValue.failUtilizationTime;
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

    var xMax = map1.length;
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryPerformanceFirstPassDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.firstPassUtilizationTime;
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


    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryPerformanceIdealCycleDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.idealCycleTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

//quality
function fetchSummaryQualityRetestPassFailed(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var failedCount = [];
    var retestCount = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;

                failedCount.push([new Date(value.date).getTime(), value.failedCount]);
                retestCount.push([new Date(value.date).getTime(), value.retestCount]);

            }
        });


    });
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'column',
            spacingLeft: 10,
            spacingRight: 10,

        },
        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,
            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
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
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');

                        //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        //         let date = new Date(selectedDate);
                        //         let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEQualityRetest.postMessage(formattedDate);

                    },
                },

            },
        },
        series: [
            {
                name: "Failed Count",
                data: failedCount,
                color: '#E90029'
            },
            {
                name: "Retest Count",
                data: retestCount,
                color: '#E76C27'
            }
        ]

    });
}

function fetchSummaryQualityFPY(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var firstPassYield = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                var fpy = ((value.firstPassCount) / (value.firstPassCount + value.retestCount + value.failedCount)) * 100;
                firstPassYield.push({ x: new Date(value.date).getTime(), y: fpy });
            }
        });

        if (!isValid) {
            firstPassYield.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },

        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEQualityFPYChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "First Pass Yield",
                data: firstPassYield,
                color: 'rgb(5, 160, 167)'
            },

            ]

    });
}

function fetchSummaryQualityYield(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var firstYield = [];
    //   params[0].data.forEach(function (value) {

    //         availableTime.push({ x: new Date(value.date).getTime(), y: value.availableTime});
    //  // OEEChannel.postMessage(value.availableTime);
    // });

    // OEEChannel.postMessage(availableTime);

    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                var fy = ((value.firstPassCount + value.retestCount) / (value.firstPassCount + value.retestCount + value.failedCount)) * 100;
                firstYield.push({ x: new Date(value.date).getTime(), y: fy });
            }
        });

        if (!isValid) {
            firstYield.push({ x: new Date(currentValue).getTime(), y: null, mVolume: null });
        }
    });


    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'line',
            spacingLeft: 10,
            spacingRight: 10,

        },

        xAxis: {
            type: "datetime",
            // tickInterval: 7 * 24 * 3600 * 1000,
            min: startDate,
            max: endDate,
        },
        yAxis: {
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        legend: {
            enabled: false,

            //x: -10,
            itemMarginBottom: 16,
            itemStyle: { "fontSize": '16px' },
        },
        plotOptions: {
            line: {
                states: {
                    inactive: {
                        opacity: 1
                    }
                },
            },
            series: {
                events: {
                    click: function (event) {
                        var selectedDate = event.point.x;
                        // //OEEClickChannel.postMessage(selectedDate);
                        // for (let data of arr) {
                        //     if (new Date(data.date).getTime() == selectedDate) {
                        let date = new Date(selectedDate);
                        let formattedDate = date.toLocaleString('sv');
                        //         var result = { "date": formattedDate, "availability": data.availability, "quality": data.quality, "performance": data.performance, "oee": data.oee };
                        //         break;
                        //     }
                        // };
                        OEEQualityYieldChannel.postMessage(formattedDate);

                    },
                },

            },
        },
        series: //availableTime
            [{
                name: "Yield",
                data: firstYield,
                color: 'rgb(115, 211, 44)'
            },

            ]

    });
}

function fetchSummaryQualityMetric(...params) {
    var startDate = Date.parse(params[1]);
    var endDate = Date.parse(params[2]);
    var quality = [];
    params[3].forEach(function (currentValue, index, arr) {
        var isValid = false;
        params[0].data.forEach(function (value) {
            if (new Date(currentValue).getTime() == new Date(value.date).getTime()) {
                isValid = true;
                quality.push({ x: new Date(value.date).getTime(), y: value.quality });
            }
        });


    });

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'areaspline',
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
                    color: 'rgba(0, 0, 0, 1)',
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
            areaspline: {
                fillOpacity: 0.2
            },
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

                        }
                    }
                }
            }
        },
        series: [{
            name: "Quality Metric",
            data: quality,
            color: "rgb(180, 226, 165)"
        }]
    });
}

//qualitydetail
function fetchSummaryQualityRetestPassFailedDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.failedCount + currentValue.retestCount;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }

    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryQualityFPYDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                var fpy = ((currentValue.firstPassCount) / (currentValue.firstPassCount + currentValue.retestCount + currentValue.failedCount)) * 100;

                totalFailedData = fpy;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryQualityYieldDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                var fy = ((currentValue.firstPassCount + currentValue.retestCount) / (currentValue.firstPassCount + currentValue.retestCount + currentValue.failedCount)) * 100;

                totalFailedData = fy;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

//summary
function fetchSummaryTotalUtilTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.totalUtilizationTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}
function fetchSummaryRetestAndFailedTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.failUtilizationTime + currentValue.retestUtilizationTime;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
}

function fetchSummaryQualityFailedTimeDetail(...params) {
    const map1 = new Map(Object.entries(params[0]));
    var totalFailResult = [];
    var sorting = '';
    for (let [key, value] of map1.entries()) {
        if (params[1].some(e => e.projectId === key && e.isSelected)) {
            var totalFailedData = 0;

            value.forEach(function (currentValue, index, arr) {
                totalFailedData = currentValue.totalFailedCount;
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

    var xMax = map1.length
    if (totalFailResult.length > 5) {
        xMax = 4;
    }
    else if (totalFailResult.length <= 5) {
        xMax = params[0].length;
    }
    chart1 = Highcharts.chart('container', {
        chart: {
            type: 'bar',
            height: 350,
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
                    color: 'rgba(0, 0, 0, 1)',
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
                        var str = data[1].toFixed(2);
                        return `
                            <div style="width: 100px; height: 30px;">
                              ${newStr}
                              <span style="color: #f4d745; margin-left: 10px;">Count:</span>
                              <span style="color: #000000;"> ${str}</span>
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
            },
            // dataSorting: {
            //     enabled: true,
            //     sortKey: sorting
            // },
            data: totalFailResult,
        }],
    });
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