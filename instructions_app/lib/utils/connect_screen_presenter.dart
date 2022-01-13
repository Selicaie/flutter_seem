import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/models/users.dart';

abstract class ConnectScreenContract {
  void onSuccess(dynamic item);
  void onError(String errorTxt);
}

class ConnectScreenPresenter {
  ConnectScreenContract _view;
  RestDatasource api = new RestDatasource();
  ConnectScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      if(user!=null)
      {
        user.password = password;
        _view.onSuccess(user);
      }
      
      else
      _view.onError("Incorrect credentials !!");
    }).catchError((error) => _view.onError("Error !! Login failed "));
  }
  // getInstructionList(String id) { 
    
  //   api.getInstructions(id).then((List<Instruction> lst) {
  //     if(lst!=null)
  //     _view.onSuccess(lst);
  //     else
  //     _view.onError("Load  instruction data failed!!");
  //   }).catchError((Exception error) => _view.onError("Error !! Login failed "));
  // }
}