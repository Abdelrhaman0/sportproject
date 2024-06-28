// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sports_project/layout/cubit/cubit.dart';
// import 'package:sports_project/layout/cubit/states.dart';
//
// class FollowersScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ProjectCubit, ProjectStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var followers = ProjectCubit.get(context).currentUserFollowers;
//
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Followers'),
//           ),
//           body: ListView.separated(
//             itemBuilder: (context, index) {
//               var user = followers[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(user.image),
//                 ),
//                 title: Text(user.name),
//                 subtitle: Text(user.bio),
//               );
//             },
//             separatorBuilder: (context, index) => Divider(),
//             itemCount: followers.length,
//           ),
//         );
//       },
//     );
//   }
// }
