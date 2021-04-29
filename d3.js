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
    line_stroke = "rgb(64, 115, 158)",
    dot_fill = "rgb(192, 57, 43, 0.5)",
    dot_stroke = "rgb(192, 57, 43, 0.75)",
    sq_fill= "rgba(64, 115, 158, 0.25)", // "rgba(76, 87, 96, 0.25)",
    sq_stroke = "rgba(64, 115, 158, 0.5)", //"rgba(76, 87, 96, 0.5)",
    xLabel = "Predictor",
    yLabel = "Response";

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
  .attr("transform",  `translate(${(width / 2) + margin}, ${height + 2 * margin})`)
  .attr("dx", "1em")
  .style("text-anchor", "middle")
  .style("font-family", "Lato, sans-serif")
  .style("font-size", "16pt")
  .text(xLabel); 

svg.append("text")
  .attr("transform", `translate(0, ${((height + 2 * margin) / 2)}) rotate(-90)`)
  .attr("dy", "1em")
  .style("text-anchor", "middle")
  .style("font-family", "Lato, sans-serif")
  .style("font-size", "16pt")
  .text(yLabel);

// Create the chart title
/*svg.append("text")
  .attr("x", (width / 2) + margin)
  .attr("y", (margin / 2))
  .attr("text-anchor", "middle")
  .attr("dx", "1em")
  .style("font-size", "18pt")
  .style("font-family", "Lato, sans-serif")
  .text(chartTitle);
*/
// The chart

// Lineplot. Keep a reference to the line object.
var line = svg.append("path")
    .datum(data.line)
    .attr("fill", "none")
    .attr("stroke", line_stroke)
    .attr("stroke-width", 3)
    .attr("d", d3.line()
      .x(function(d) {return xScale(d.x)})
      .y(function(d) {return yScale(d.y) + margin})
      );

// Listen to clicks on plot and set input$new_point
svg.on('click', function(event) {
  var [x, y] = d3.pointer(event);
  if (x > margin && x < (width + 0.9 * margin) && y > margin && y < (height + 0.9 * margin)) {
    Shiny.setInputValue(
      "new_point", 
      [xScale.invert(x), yScale.invert(y - margin)], 
      {priority : "event"}
    );
  }
});

// For further data coming we use r2d3.onRender because we only update the 
// dots, squares, lines, but not the layout.

r2d3.onRender(function(data, svg, width, height, options) {
    
  svg.selectAll('circle')
    .data(data.scatter)
    .enter()
    .append('circle')
    .attr("cx", function(d) {return xScale(d.x)})
    .attr("cy", function(d) {return yScale(d.y) + margin})
    .attr("r", 6)
    .style("fill", dot_fill)
    .style("stroke", dot_stroke);
    
  svg.selectAll('circle').exit().remove();
    
  svg.selectAll('circle')
    .data(data.scatter)
    .transition()
    .ease(d3.easeElastic)
    .duration(500)
    .attr("cx", function(d) {return xScale(d.x)})
    .attr("cy", function(d) {return yScale(d.y) + margin});
  
  
  if (data.scatter.length == 0) {
    svg.selectAll('circle')
      .transition()
      .attr("r", 0)
      .remove();
  }

  // Update line
  line
    .datum(data.line)
    .transition()
    .duration(500)
    .attr("d", d3.line()
      .x(function(d) {return xScale(d.x)})
      .y(function(d) {return yScale(d.y) + margin})
    );

  // Create and update rects
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

  if (data.rect.length == 0) {
    svg.selectAll('rect')
      .transition()
      .attr('x', function(d) {
        return this.getBBox().x + (this.getBBox().width / 2);
      })
      .attr('y', function(d) {
        return this.getBBox().y + (this.getBBox().height / 2);
      })
      .attr('width', 0)
      .attr('height', 0)
      .remove();
      
      // https://stackoverflow.com/questions/21990857/d3-js-how-to-get-the-computed-width-and-height-for-an-arbitrary-element
  }
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

/*
Old function
function drawCircle(x, y) {
  svg.append("circle")
    .attr("cx", x)
    .attr("cy", y)
    .attr("r", 6)
    .style("fill", dot_fill)
    .style("stroke", dot_stroke);
}
*/