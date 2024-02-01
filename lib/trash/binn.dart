// Widget seePost() {
//   return Column(
//     children: [
//       // ... (other widgets)
//
//       Container(
//         decoration: BoxDecoration(border: Border.all()),
//         height: 300,
//         width: 380,
//         child: GoogleMap(
//           onMapCreated: (GoogleMapController controller) {
//             mapController = controller;
//           },
//           initialCameraPosition: CameraPosition(
//             target: LatLng(latitude ?? 0.0, longitude ?? 0.0),
//             zoom: 12.0,
//           ),
//           markers: <Marker>{
//             Marker(
//               markerId: MarkerId('initialPosition'),
//               position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
//               infoWindow: InfoWindow(
//                 title: 'Marker Title',
//                 snippet: 'Marker Snippet',
//               ),
//             ),
//           },
//         ),
//       ),
//       SizedBox(height: 10),
//     ],
//   );
// }
