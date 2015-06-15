/*Colors for the clustering of Mexican electoral preferences*/
var clusterColors = ["#E41A1C", "#FFFF33","#2166AC",
		     "#610200", "#f58e1e","#37b4b7", "#bd0026",
                     "#d5b60a", "white"];
/*The intuitive names of the clusters*/
var clusterNames = ["PRI", "PAN", "PRD","MORENA",
		    "MC", "PANAL", "PRI+PVEM", "PRD+PT", ""];
//legend labels
var cutPoints = ["(0%, 7.4%]", "(7.4%, 14.9%]", "(14.9%, 22.3%]",
		 "(22.3%, 29.8%]",
		 "(29.8%, 37.2%]", "(37.2%, 44.7%]",
		 "(44.7%, 52.2%]", "(52.2%, 59.6%]", "(59.6%, 79%]"];

var feature, selection = "PRI";
var digit = d3.format(".1%");
var digit0 = d3.format(".0%");



var choose_scale=function(party){
    switch(party) {
    case "PRI":
        return pri_scale;
        break;
    case "PRD":
        return prd_scale;
        break;
    case "PAN":
        return pan_scale;
        break;
    case "MORENA":
        return morena_scale;
        break;
    case "PVEM":
        return pvem_scale;
        break;
    case "MOVIMIENTO_CIUDADANO":
        return mc_scale;
        break;
    case "NUEVA_ALIANZA":
        return panal_scale;
        break;
    case "PS":
        return ps_scale;
        break;
    case "PRIPVEM":
        return pripvem_scale;
        break;
    case "PRDPT":
        return prdpt_scale;
        break;
    }
}


colorScale = function(){
    if (selection == "PRI")
        return colorbrewer.Reds[9];
    else if (selection == "PAN")
        return colorbrewer.Blues[9];
    else if (selection == "PRD")
        return colorbrewer.YlOrBr[9];
};
var color = function() { return d3.scale.quantize()
			 .domain([0, .691])
			 .range(colorScale());};

var caption = d3.select('#caption')
, starter = caption.html();
function showCaption(d, i) {
    barData = [d.properties.PRI, d.properties.PRD, d.properties.PAN,
               d.properties.MORENA, d.properties.PVEM,
               d.properties.MOVIMIENTO_CIUDADANO,
               d.properties.NUEVA_ALIANZA, d.properties.PS,
               d.properties.PRIPVEM, d.properties.PRDPT];
    redraw();
    caption.html(//["PRI:", digit(d.properties.PRI),
        // "PRD:", digit(d.properties.PRD),
        // "PAN:", digit(d.properties.PAN)].join(" ") +
        d.properties.NOMDISTRITO);
}

var map = L.map('map').setView([23.8, -100], 5);

var cloudmade = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png', {
    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
    subdomains: 'abcd',
    minZoom: 0,
    maxZoom: 20}).addTo(map);

/* Initialize the SVG layer */
map._initPathRoot()  ;
/* We simply pick up the SVG from the map object */
var svg = d3.select("#map").select("svg"),
    g = svg.append("g");

var svg = d3.select(map.getPanes().overlayPane).append("svg"),
    g = svg.append("g").attr("class", "leaflet-zoom-hide");

var pri_scale = chroma.scale([chroma('#ec242a').brighten(90).hex() , '#ec242a']).domain([0,.7], 9),
    pan_scale = chroma.scale([chroma('#02569b').brighten(90).hex(), '#02569b']).domain([0,.7], 9),
    prd_scale = chroma.scale([chroma('#fec44f').brighten(90).hex(), '#fec44f']).domain([0,.7], 9),
    morena_scale = chroma.scale([chroma('#d95f0e').brighten(90).hex(), '#d95f0e']).domain([0,.7], 9),
    pvem_scale = chroma.scale([chroma('#2ca25f').brighten(90).hex(), '#2ca25f']).domain([0,.7], 9),
    mc_scale = chroma.scale([chroma( '#f58e1e').brighten(90).hex(), '#f58e1e']).domain([0,.7], 9),
    ps_scale = chroma.scale([chroma('#643179').brighten(90).hex(), '#643179']).domain([0,.7], 9),
    panal_scale = chroma.scale([chroma('#37b4b7').brighten(90).hex(), '#37b4b7']).domain([0,.7], 9),
    pripvem_scale = chroma.scale([chroma('#bd0026').brighten(90).hex(), '#bd0026']).domain([0,.7], 9),
    prdpt_scale = chroma.scale([chroma('#d5b60a').brighten(90).hex(), '#d5b60a']).domain([0,.7], 9);

//Initial color legend
for(i=0;i<9;i++) {
    d3.select("#n" + i).style("background", choose_scale("PRI")(choose_scale("PRI").domain()[(i)]).hex());
    d3.select("#t" + i).html(cutPoints[i]);
}

d3.json("final.json", function(topology) {
    var bounds = d3.geo.bounds(topojson.object(topology, topology.objects.distritos)),
	path = d3.geo.path().projection(project);

    feature = g.selectAll("path")
	.data(topojson.object(topology, topology.objects.distritos).geometries)
	.enter().append("path")
	.style("fill",function(d) { return choose_scale("PRI")(d.properties["PRI"]).hex();;  })
	.on('mouseover', showCaption)
	.on('mousemove', showCaption)
	.on('mouseout', function() {
	    caption.html(starter);
	    barData = [.292, .109, .210, .084, .069, .061, .037, .033, 0, 0];
	    redraw();
	});
    ;


    map.on("viewreset", reset);
    reset();

    // Reposition the SVG to cover the features.
    function reset() {
	var bottomLeft = project(bounds[0]),
	    topRight = project(bounds[1]);

	svg .attr("width", topRight[0] - bottomLeft[0])
	    .attr("height", bottomLeft[1] - topRight[1])
	    .style("margin-left", bottomLeft[0] + "px")
	    .style("margin-top", topRight[1] + "px");

	g   .attr("transform", "translate(" + -bottomLeft[0] + "," + -topRight[1] + ")");

	feature.attr("d", path);
    }



    // Use Leaflet to implement a D3 geographic projection.
    function project(x) {
	var point = map.latLngToLayerPoint(new L.LatLng(x[1], x[0]));
	return [point.x, point.y];
    }
});




d3.select("select").on("change", function() {
    selection = this.value.toString();
    if(selection != "Winner")
	for(i=0;i<9;i++) {
	    d3.select("#n" + i).style("background", choose_scale(selection)(choose_scale(selection).domain()[(i)]).hex());
	    d3.select("#t" + i).html(cutPoints[i]);
	}
    else
	for(i=0;i<9;i++) {
	    d3.select("#n" + i).style("background",clusterColors[i]);
	    d3.select("#t" + i).html(clusterNames[i]);
	}
    d3.selectAll("path").style("fill",function(d) {
	if (selection == "Winner")
	    return d.properties.color;
	else
            return choose_scale(selection)(d.properties[selection]).hex();
    });
});
