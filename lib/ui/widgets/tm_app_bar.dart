import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';
import 'package:taskmanager/ui/screens/update_profile_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.fromUpdateProfile,
  });

  final bool? fromUpdateProfile;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    //final profilePhoto = AuthController.userModel!.photo;
    final user = context.watch<StateManager>().user ?? AuthController.userModel!;
    final profilePhoto = user.photo;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: (){
          if(widget.fromUpdateProfile ?? false){
            return;
          }
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              child: profilePhoto.isNotEmpty ?
            Image.memory(jsonDecode(profilePhoto))
            : Icon(Icons.person),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white
                )),
                Text(AuthController.userModel!.email, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white
                )),
              ],
            )

          ],
        ),
      ),
      actions: [IconButton(onPressed: _signOut, icon: Icon(Icons.logout))],
    );
  }

  Future<void> _signOut() async{
    context.read<StateManager>().clearUser();
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.name, (predicate) => false);
  }
}
