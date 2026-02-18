import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';

class LocationTagListTile extends StatelessWidget {
  const LocationTagListTile({super.key});

  @override
  Widget build(BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.location_on_outlined,
              color: colorScheme.inversePrimary,
            ),
            title: MyText(text: "Add Location", fontSize: 16),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.inversePrimary.withOpacity(0.5),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.person_add_alt_1_outlined,
              color: colorScheme.inversePrimary,
            ),
            title: MyText(text: "Tag People", fontSize: 16),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.inversePrimary.withOpacity(0.5),
            ),
            onTap: () {},
          ),
      ],
    );
  }
}