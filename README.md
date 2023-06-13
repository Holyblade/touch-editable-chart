# Flutter Graph Plotting Library

The Flutter Graph Plotting Library is a versatile tool that allows developers to effortlessly plot and customize graphs in their Flutter applications. Built on the foundations of Dart, this library empowers users to create interactive graphs with ease and customize their appearance and style according to their preferences. With support for touch gestures, users can interact with the graphs, read data, and even modify vertex values.

## Features

- Touch Interaction: The library enables touch interaction, allowing users to effortlessly drag and update the position of data points on the graph.
- Responsiveness: The chart automatically adjusts its width and height to fit the available space based on the device's screen size. It utilizes the MediaQuery to obtain the screen dimensions, ensuring a responsive layout.
- Data Editing: Users can dynamically edit the chart's data in real-time. When a data point is dragged on the chart, the corresponding FlSpot object is updated to reflect the new position.
- X-Axis Constraint: The chart enforces a constraint on the movement of data points along the x-axis. Each point can only be moved within the x-range defined by its neighboring points. This ensures that data points cannot cross the x-axis boundaries set by adjacent points.
- Visual Feedback: The chart provides visual feedback to the user during interactions. The selected point can be highlighted or visually differentiated, indicating its active state.

By leveraging these powerful functionalities, developers can effortlessly implement interactive line charts in their Flutter applications. Users can manipulate and customize data points with ease, providing an engaging and dynamic graphing experience.
