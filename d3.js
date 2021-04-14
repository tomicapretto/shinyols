// These variables are already created
// data — The R data converted to JavaScript.
// svg — The svg container for the visualization
// width — The current width of the container
// height — The current height of the container
// options — Additional options provided by the user
// theme — Colors for the current theme
// We can acces them as 'data' or 'r2d3.data'

// Set some initial values
var margin = 50,
    width = width - (2 * margin), 
    height = height - (2 * margin),
    xmax = 13,
    xmin = 0,
    ymax = 13
    ymin = 0,
    barPadding = 0.1,
    colour = "rgba(255,0,0,1)",
    sq_fill= "rgba(70,130,180, 0.4)",
    sq_stroke = "rgba(70,130,180, 0.7)"
    hovercolour = "rgba(50,50,50,1)",
    xLabel = "Predictor",
    yLabel = "Response",
    chartTitle = "Least squares fit";

// Create the axes
xScale = d3.scaleLinear()
    .range([margin, margin + width])
    .domain([xmin, xmax]);
yScale = d3.scaleLinear()
    .range([height, 0])
    .domain([ymin, ymax]);

// Append axes
svg.append("g")
  .attr("transform", "translate(" + 0 + "," + (margin + yScale(0)) + ")")
  .call(d3.axisBottom(xScale));
svg.append("g")
  .attr("transform", "translate(" + xScale(0) + ", " + margin + ")")
  .call(d3.axisLeft(yScale));


// Axes labels
svg.append("text")
  .attr("transform", "translate(" + (width/2) + " ," + (height+2*margin) + ")")
  .attr("dx", "1em") .style("text-anchor", "middle")
  .style("font-family", "Tahoma, Geneva, sans-serif")
  .style("font-size", "12pt") .text(xLabel); 

svg.append("text") .attr("transform", "translate(" + 0 + " ," + ((height+2*margin)/2) + ") rotate(-90)")
  .attr("dy", "1em")
  .style("text-anchor", "middle")
  .style("font-family", "Tahoma, Geneva, sans-serif")
  .style("font-size", "12pt")
  .text(yLabel);

// Create the chart title
svg.append("text")
  .attr("x", (width / 2))
  .attr("y", (margin / 2))
  .attr("text-anchor", "middle")
  .attr("dx", "1em")
  .style("font-size", "16pt")
  .style("font-family", "Tahoma, Geneva, sans-serif")
  .text(chartTitle);

// Create the chart
// Lineplot
var line = svg.append("path")
    .datum(data.line)
    .attr("fill", "none")
    .attr("stroke", "steelblue")
    .attr("stroke-width", 2.5)
    .attr("d", d3.line()
      .x(function(d) { return xScale(d.x)})
      .y(function(d) { return yScale(d.y) + margin})
      );

// Squares
/*svg.selectAll('rect')
  .data(data.rect)
  .enter()
  .append('rect')
  .attr('x', function(d) {return xScale(d.x);})
  .attr('y', function(d) {return yScale(d.y);})
  .attr('width', function(d) {return scale_rect_width(d);})
  .attr('height', function(d) {return scale_rect_height(d);})
  .attr('stroke', sq_stroke)
  .attr('stroke-width', '2')
  .attr('fill', sq_fill);*/

// Listen to clicks on plot
svg.on('click', function(event) {
  var [x, y] = d3.pointer(event);
  Shiny.setInputValue("new_point",
    [xScale.invert(x), yScale.invert(y - margin)], {priority : "event"}
  );
  drawCircle(x, y);
});

function drawCircle(x, y) {
  svg.append("circle")
    .attr("cx", x)
    .attr("cy", y)
    .attr("r", 4)
    .style("fill", colour);
}

// For further data coming we use r2d3.onRender because we only update the 
// dots, squares, lines, but not the layout.

r2d3.onRender(function(data, svg, width, height, options) {
  // Create and update circles
  
  /*svg.selectAll('dot')
    .data(data.scatter)
    .enter()
    .append("circle")
    .attr("cx", function (d) {return xScale(d.x); } )
    .attr("cy", function (d) {return yScale(d.y) + margin;} )
    .attr("r", function (d) { return 4;})
    .style("fill", colour);*/
  
  // Pasar un "shake", y si "shake" es TRUE, utilizamos el transition
  
   /*svg.selectAll("circle")
    .data(data.scatter)
    .transition()
    .duration(500)
    .attr("cx", function (d) {return xScale(d.x);})
    .attr("cy", function (d) {return yScale(d.y) + margin;});*/
  
  // Update line
  line
    .datum(data.line)
    .transition()
    .duration(500)
    .attr("d", d3.line()
      .x(function(d) {return xScale(d.x)})
      .y(function(d) {return yScale(d.y) + margin})
    );


    svg.selectAll('rect')
      .data(data.rect)
      .enter()
      .append('rect')
      .attr('x', function(d) {return xScale(d.x);})
      .attr('y', function(d) {return yScale(d.y) + margin;})
      .attr('width', function(d) {return scale_rect_width(d);})
      .attr('height', function(d) {return scale_rect_height(d);})
      .attr('stroke', sq_stroke)
      .attr('stroke-width', '2')
      .attr('fill', sq_fill);

    svg.selectAll('rect')
      .data(data.rect)
      .transition()
      .duration(500)
      .attr('x', function(d) {return xScale(d.x);})
      .attr('y', function(d) {return yScale(d.y) + margin;})
      .attr('width', function(d) {return scale_rect_width(d);})
      .attr('height', function(d) {return scale_rect_height(d);});
});

// Helper functions
function scale_rect_width(d) {
    // The distance from left border to X 
    // MINUS
    // the distance from left border to X - WIDTH
    // gives the width in px
    return xScale(d.x) - xScale(d.x - d.width);
};


function scale_rect_height(d) {
    // The distance from top border to Y - HEIGHT 
    // MINUS
    // the distance from top border to Y
    // gives the height in px
    return yScale(d.y - d.height) - yScale(d.y);
};
