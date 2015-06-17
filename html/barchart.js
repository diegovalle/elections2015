//final results of the 2015 election
var barData = [.292, .109, .210, .084, .069, .061, .037, .033, 0, 0, .006];
var gap = 2;
var maxper= .8;
//padding for the party labels
var left_padding = 60;
var w = 300,
    h = 240;

var x = d3.scale.linear()
        .domain([0, maxper])
        .range([0, w-40]);
var y = d3.scale.ordinal()
        .domain(barData)
        .rangeBands([0, h]);

var chart = d3.select(".chart").append("svg")
        .attr("class", "chart")
        .attr("width", w+left_padding+10)
        .attr("height", h)
        .append("g")
        .attr("transform", "translate(20,15)");

//the lines at 20,40,60
chart.selectAll("line")
    .data(x.ticks(3))
    .enter().append("line")
    .attr("x1", function(d) { return x(d) + left_padding; })
    .attr("x2", function(d) { return x(d) + left_padding; })
    .attr("y1", -3)
    .attr("y2", h - 10)
    .style("stroke", function(d, i) {return i == 0 ? "#000": "#bbb";});

//the text at the top of the lines
chart.selectAll(".rule")
    .data(x.ticks(3))
    .enter().append("text")
    .attr("class", "rule")
    .attr("x", function(d) { return x(d) + left_padding; })
    .attr("y", 0)
    .attr("dy", -4)
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .text(function(d){return digit0(d)});

//the bars
chart.selectAll("rect")
    .data(barData)
    .enter().append("rect")
    .attr("x", function(d, i) { return left_padding; })
    .attr("y", function(d, i) { return i * 20; })
    .attr("width", x)
    .attr("height", 20)
    .attr("fill",  function(d, i) { if(i == 1) return "#FFFF33";
                                    if(i == 2) return "#377EB8";
                                    if(i == 0) return "#E41A1C";
                                    if(i == 3) return "#d95f0e";
                                    if(i == 4) return "#2ca25f";
                                    if(i == 5) return "#f58e1e";
                                    if(i == 6) return "#37b4b7";
                                    if(i == 7) return "#643179";
                                    if(i == 8) return "#bd0026";
                                    if(i == 9) return "#d5b60a";
                                    if(i == 10) return "4d4d4d";});

//labels for the parties
chart.selectAll("text.name")
    .data(["PRI", "PRD", "PAN", "MORENA", "PVEM", "MC", "PANAL", "PS", "PRI+PVEM", "PRD+PT", "INDEP"])
    .enter().append("text")
    .attr("x", 0)
    .attr("y", function(d, i){ return i * 20 + 10; } )
    .attr("dy", ".36em")
    .attr("text-anchor", "left")
    .attr('class', 'name')
    .attr("font-size", 12)
    .attr("font-family","'Ubuntu',Tahoma,sans-serif")
    .text(String);

function redraw() {

    // Update…
    chart.selectAll("rect")
        .data(barData)
	.transition()
        .duration(400)
        .attr("y", function(d, i) { return i * 20; })
	.attr("width", x);

    chart.selectAll("text")
	.data(barData)
	.enter().append("text")
	.attr("stroke", "black")
	.attr("x", x)
	.attr("y", function(d) { return y(d) + y.rangeBand() / 2; })
	.attr("dx", -3) // padding-right
	.attr("dy", ".35em") // vertical-align: middle
	.attr("text-anchor", "end") // text-align: right
	.text(String);
}
