import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';

class UserDetailsPage extends StatelessWidget {
  final UserEntity userEntity;

  const UserDetailsPage({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userEntity.firstName} ${userEntity.lastName}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 16,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(
                  userEntity.profilePicture,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'User Name',
              content: '${userEntity.firstName} ${userEntity.lastName}',
            ),
            _buildInfoCard(title: 'Email address', content: userEntity.email),
            _buildInfoCard(title: 'User ID', content: userEntity.id.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
