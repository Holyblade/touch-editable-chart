# Flutter Graph Plotting Library

A Dart and C++ project based. The Flutter Graph Plotting Library is a versatile tool that allows users to plot and customize graphs in Flutter applications. With this library, users can easily create interactive graphs and customize their appearance and style. The library supports touch gestures for data reading and even allows users to modify vertex values.

## Features

- Touch Interaction: The chart supports touch interaction, allowing the user to drag and update the position of the data points.
- Responsiveness: The chart automatically adjusts its width and height to fit the available space based on the device's screen size, utilizing the MediaQuery to obtain the screen dimensions.
- Data Editing: When the user drags a data point on the chart, the corresponding FlSpot object is updated to reflect the new position. This enables real-time editing of the chart's data.
- X-Axis Constraint: The chart enforces a constraint on the x-axis movement of the data points. Each point can only be moved within the x-range defined by its neighboring points. This prevents the data points from crossing the x-axis boundaries set by adjacent points.
- Visual Feedback: The chart provides visual feedback to the user when interacting with the data points. The selected point can be highlighted or visually differentiated to indicate its active state.

By utilizing these functionalities, developers can easily implement an interactive line chart in their Flutter applications, allowing users to manipulate and customize the data points according to their preferences.
