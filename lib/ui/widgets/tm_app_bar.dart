import 'package:flutter/material.dart';
import 'package:taskmanager/ui/screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.fromUpdateProfile,
  });

  final bool? fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: (){
          if(fromUpdateProfile ?? false){
            return;
          }
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white
                )),
                Text('Name@gmail.com', style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white
                )),
              ],
            )
        
          ],
        ),
      ),
      actions: [Icon(Icons.logout, color: Colors.white,)],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
