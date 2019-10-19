import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardWidget extends StatelessWidget {
  final List<String> _imageUrl;
  final String _texto;

  CardWidget(this._texto, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _crearContenedor(),
      onTap: () {
        print("presionado");
      },
    );
  }

  Widget _crearContenedor() {
    return Center(
      child: SizedBox(
        width: 450,
        height: 325,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(0.0, 10.0),
                    spreadRadius: 0,
                    blurRadius: 10)
              ]),
          child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _crearImagenFondo(),
                  Column(
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 10)),
                      Expanded(child: Container()),
                      _mensaje()
                    ],
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
        ),
      ),
    );
  }

  Widget _crearImagenFondo() {
    return Hero(
      child: CachedNetworkImage(
        imageUrl: _imageUrl[0],
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      tag: _texto,
    );
  }

  Widget _mensaje() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(bottom: 20, left: 20),
      child: Container(
        child: Text(
          _texto,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            color: Color.fromARGB(80, 0, 0, 0)),
        padding: new EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 2.0),
      ),
    );
  }
}
