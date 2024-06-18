
import 'package:sports_project/models/comment_model.dart';

abstract class ProjectStates {}

class ProjectInitialState extends ProjectStates{}

class ProjectGetUserLoadingState extends ProjectStates{}

class ProjectGetUserSuccessState extends ProjectStates{}

class ProjectGetUserErrorState extends ProjectStates{
  final String error;

  ProjectGetUserErrorState(this.error);
}

class ProjectGetAllUserLoadingState extends ProjectStates{}

class ProjectGetAllUserSuccessState extends ProjectStates{}

class ProjectGetAllUserErrorState extends ProjectStates{
  final String error;

  ProjectGetAllUserErrorState(this.error);
}

class ProjectAddPostState extends ProjectStates{}

class ProjectChangeBottomNavState extends ProjectStates{}

class ProjectProfilePickedImageSuccessState extends ProjectStates{}

class ProjectProfilePickedImageErrorState extends ProjectStates{}

class ProjectCoverPickedImageSuccessState extends ProjectStates{}

class ProjectCoverPickedImageErrorState extends ProjectStates{}

class ProjectUploadProfileImageSuccessState extends ProjectStates{}

class ProjectUploadProfileImageErrorState extends ProjectStates{}

class ProjectUploadCoverImageSuccessState extends ProjectStates{}

class ProjectUploadCoverImageErrorState extends ProjectStates{}

class ProjectUploadUserErrorState extends ProjectStates{}

class ProjectUploadUserLoadingState extends ProjectStates{}

class ProjectCreatePostLoadingState extends ProjectStates{}

class ProjectCreatePostSuccessState extends ProjectStates{}

class ProjectCreatePostErrorState extends ProjectStates{}

class ProjectPostPickedImageSuccessState extends ProjectStates{}

class ProjectPostPickedImageErrorState extends ProjectStates{}

class ProjectRemovePostImageSuccessState extends ProjectStates{}

class ProjectGetPostLoadingState extends ProjectStates{}

class ProjectGetPostSuccessState extends ProjectStates{}

class ProjectGetPostErrorState extends ProjectStates{
  final String error;

  ProjectGetPostErrorState(this.error);
}

class ProjectSendMassageErrorState extends ProjectStates{}

class ProjectSendMassageSuccessState extends ProjectStates{}

class ProjectGetMassageSuccessState extends ProjectStates{}

class ProjectGetLikesSuccessState extends ProjectStates{}

class ProjectGetLikesErrorState extends ProjectStates{
  final String error;

  ProjectGetLikesErrorState(this.error);
}

class NewsGetSportsLoadingState extends ProjectStates{}

class NewsGetSportsSuccessState extends ProjectStates{}

class NewsGetSportsErrorState extends ProjectStates{
  final String error;
  NewsGetSportsErrorState(this.error);
}

class ProjectCreateCommentLoadingState extends ProjectStates{}

class ProjectCreateCommentSuccessState extends ProjectStates{}

class ProjectCreateCommentErrorState extends ProjectStates{}

class ProjectGetCommentLoadingState extends ProjectStates{}

class ProjectGetCommentSuccessState extends ProjectStates{}

class ProjectGetCommentErrorState extends ProjectStates{
  final String error;

  ProjectGetCommentErrorState(this.error);
}

class ProjectGetCommentEmptyState extends ProjectStates{}

class ProjectSignOutLoadingState extends ProjectStates{}

class ProjectSignOutSuccessState extends ProjectStates{}

class ProjectSignOutErrorState extends ProjectStates{}

class ProjectPostVideoPickedSuccessState extends ProjectStates{}

class ProjectPostVideoPickedErrorState extends ProjectStates{}

class ProjectPostVideoRemovedState extends ProjectStates{}

class ProjectVideoInitializedState extends ProjectStates{
  final String postId;

  ProjectVideoInitializedState(this.postId);
}

class ProjectVideoPlayPauseState extends ProjectStates{}

class ProjectCommentsLoaded extends ProjectStates {
  final List<CommentModel> comments;

  ProjectCommentsLoaded(this.comments);
}
