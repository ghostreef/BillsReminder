
/*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
nv.addGraph(function () {
    var chart = nv.models.lineChart()
            .margin({left: 100})  //Adjust chart margins to give the x-axis some breathing room.
            .useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
            //.transitionDuration(350)  //how fast do you want the lines to transition?
            .showLegend(true)       //Show the legend, allowing users to turn on/off line series.
            .showYAxis(true)        //Show the y-axis
            .showXAxis(true)        //Show the x-axis
            .options({
                transitionDuration: 300,
                useInteractiveGuideline: true
            })
        ;

        // this can also be done, instead of using options
        // .transition().duration(500)

    chart.xAxis     //Chart x-axis settings
        .axisLabel('Date')
        //.ticks(d3.time.months)
        .tickValues(tv())
        .tickFormat(function(d) { return d3.time.format('%b')(new Date(d)); }); // is the function required?


    chart.yAxis     //Chart y-axis settings
        .axisLabel('Spending ($)')
        .tickFormat(d3.format('d'));

    /* Done setting the chart up? Time to render it!*/
    var myData = fakeSpendingActivity();   //You need data...



    console.log(myData);
    d3.select('#chart svg')    //Select the <svg> element you want to render the chart in.
        .datum(myData)         //Populate the <svg> element with chart data...
        .call(chart);          //Finally, render the chart!

    //Update the chart when window resizes.
    nv.utils.windowResize(function () {
        chart.update()
    });
    return chart;
});





/**************************************
 * Simple test data generator
 */

function days(num) {
    return num*60*60*1000*24
}

function fakeActivityByDate() {
    var lineData = [];
    var y = 0;
    var start_date = new Date() - days(365); // one year ago

    for (var i = 0; i < 100; i++) {
        lineData.push({x: new Date(start_date + days(i)), y: y});
        y=y+Math.floor((Math.random()*10)-3);
    }

    return [
        {
            values: lineData,
            key: 'Activity',
            color: '#ff7f0e'
        }
    ];
}

// just get the months, if you don't explicitly pass in months, d3 will expand months on window resize
function tv () {
    var dtv = [];
    for (var i = 0; i < 12; i++) {
        var d =  new Date(2016, i, 1);
        dtv.push(d);
    }
    return dtv;
}

function fakeSpendingActivity() {
    var lineData = [];

    for (var i = 0; i < 12; i++) {

        var d =  new Date(2016, i, 1);
        var y = Math.floor(Math.random() * 100);

        lineData.push({x: d, y: y});

    }

    // NOTE key cannot be the same
    return [
        {
            values: fakeLineData(),
            key: 'Spent'
            //,color: '#ff7f0e'
        }
        ,{
            values: fakeLineData(),
            key: 'A'
        }
        ,{
            values: fakeLineData(),
            key: 'B'
        }
        ,{
            values: fakeLineData(),
            key: 'C'
        }
        ,{
            values: fakeLineData(),
            key: 'D'
        }
        ,{
            values: fakeLineData(),
            key: 'E'
        }
        ,{
            values: fakeLineData(),
            key: 'F'
        }
    ];
}


function fakeLineData() {
    var lineData = [];

    for (var i = 0; i < 12; i++) {

        var d =  new Date(2016, i, 1);
        var y = Math.floor(Math.random() * 100);

        lineData.push({x: d, y: y});

    }

    return lineData;
}



function sinAndCos() {
    var sin = [], sin2 = [],
        cos = [];

    //Data is represented as an array of {x,y} pairs.
    for (var i = 0; i < 100; i++) {
        sin.push({x: i, y: Math.sin(i / 10)});
        sin2.push({x: i, y: Math.sin(i / 10) * 0.25 + 0.5});
        cos.push({x: i, y: .5 * Math.cos(i / 10)});
    }

    //Line chart data should be sent as an array of series objects.
    return [
        //{
        //    values: [],      //values - represents the array of {x,y} data points
        //    key: 'Sine Wave', //key  - the name of the series.
        //    color: '#ff7f0e'  //color - optional: choose your own line color.
        //},
        //{
        //    values: [],
        //    key: 'Cosine Wave',
        //    color: '#2ca02c'
        //},
        {
            values: [{x: 'Jan', y: 1}],
            key: 'Another sine wave',
            color: '#7777ff',
            area: true      //area - set to true if you want this line to turn into a filled area chart.
        }
    ];
}

