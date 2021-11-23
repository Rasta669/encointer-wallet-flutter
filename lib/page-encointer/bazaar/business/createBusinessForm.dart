import 'dart:io';

import 'package:encointer_wallet/common/components/roundedButton.dart';
import 'package:encointer_wallet/page-encointer/bazaar/common/imagePickerHandler.dart';
// import 'package:encointer_wallet/page/account/txConfirmPage.dart';
// import 'package:encointer_wallet/service/ipfsApi/httpApi.dart';
import 'package:encointer_wallet/store/app.dart';
// import 'package:encointer_wallet/store/encointer/types/bazaar.dart';
import 'package:encointer_wallet/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateBusinessForm extends StatefulWidget {
  CreateBusinessForm(this.store);

  final AppStore store;
  static final String route = '/encointer/bazaar/createBusinessForm';

  @override
  _CreateBusinessForm createState() => _CreateBusinessForm(store);
}

class _CreateBusinessForm extends State<CreateBusinessForm> {
  _CreateBusinessForm(this.store);

  final AppStore store;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _descriptionCtrl = new TextEditingController();
  File _imageFile;

  // upload Image to IPFS
  // Future<String> _uploadImage() async {
  //   File image = File(_imageFile.path);
  //   final String imageHash = await Ipfs().uploadImage(image);
  //   return imageHash;
  // }

  // upload Json to IPFS
  // Future<String> _uploadBusiness(IpfsBusiness business) async {
  //   var jsonToUpload = business.toJson();
  //   final String businessHash = await Ipfs().uploadJson(jsonToUpload);
  //   return businessHash;
  // }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      // upload business image to ipfs
      // final String _imageHash = await _uploadImage();

      // This part is commented out because the types used here do no longer exist.
      // revamp, the flow here should be implemented as follows in the future:
      //
      // 1. Upload an `IpfsBusiness` to ipfs. As ipfs-cid is returned as a result
      // 2. Register that business with the chain by sending a `register_business` extrinsic

      // create business with newly generated image hash
      // Business newBusiness = new Business(
      //   name: _nameCtrl.text.trim(),
      //   description: _descriptionCtrl.text.trim(),
      //   imageHash: _imageHash,
      // );
      // final String _businessHash = await _uploadBusiness(newBusiness);
      //
      // var args = {
      //   "title": 'new_business',
      //   "txInfo": {
      //     "module": 'encointerBazaar',
      //     "call": 'newBusiness',
      //   },
      //   "detail": jsonEncode({
      //     "cid": store.encointer.chosenCid,
      //     "name": _nameCtrl.text.trim(),
      //     "description": _descriptionCtrl.text.trim(),
      //   }),
      //   "params": [
      //     store.encointer.chosenCid,
      //     _businessHash,
      //   ],
      //   'onFinish': (BuildContext txPageContext, Map res) {
      //     Navigator.popUntil(txPageContext, ModalRoute.withName('/'));
      //   }
      // };
      // Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).bazaar;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  // business name
                  decoration: InputDecoration(
                    icon: Icon(Icons.cake, color: Colors.blueAccent),
                    hintText: dic['business.name'],
                    labelText: "${dic['business.name']}",
                  ),
                  controller: _nameCtrl,
                ),
                TextFormField(
                  // business description
                  decoration: InputDecoration(
                    icon: Icon(Icons.favorite, color: Colors.pink),
                    hintText: dic['business.description'],
                    labelText: "${dic['business.description']}",
                  ),
                  controller: _descriptionCtrl,
                ),
                _previewImage(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: RoundedButton(
                    text: I18n.of(context).bazaar['image.choose'],
                    onPressed: () => _getImage(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: RoundedButton(
              text: I18n.of(context).bazaar['business.create'],
              onPressed: () {
                _submit();
              },
            ),
          ),
        ],
      ),
    );
  }

  // route to imagePickerHandler
  Future<void> _getImage() async {
    final image = await Navigator.push(
      context,
      PageRouteBuilder(opaque: false, pageBuilder: (context, _, __) => ImagePickerHandler()),
    );
    // only update image when new picture is chosen
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(File(_imageFile.path)),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet chosen an image.',
        textAlign: TextAlign.center,
      );
    }
  }
}