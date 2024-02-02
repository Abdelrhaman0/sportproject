
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