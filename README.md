# Touch Editable Chart

A Dart and C++ project based.

## Getting Started

- Added support for flutter 3.10.2.
- Required dart 3 & null safey.
- Required min SDK version 21.
- Touch Interaction: The chart supports touch interaction, allowing the user to drag and update the position of the data points.
- Responsiveness: The chart automatically adjusts its width and height to fit the available space based on the device's screen size, utilizing the MediaQuery to obtain the screen dimensions.
- Data Editing: When the user drags a data point on the chart, the corresponding FlSpot object is updated to reflect the new position. This enables real-time editing of the chart's data.
- X-Axis Constraint: The chart enforces a constraint on the x-axis movement of the data points. Each point can only be moved within the x-range defined by its neighboring points. This prevents the data points from crossing the x-axis boundaries set by adjacent points.
- Visual Feedback: The chart provides visual feedback to the user when interacting with the data points. The selected point can be highlighted or visually differentiated to indicate its active state.

By utilizing these functionalities, developers can easily implement an interactive line chart in their Flutter applications, allowing users to manipulate and customize the data points according to their preferences.