import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Informações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Desenvolvido por Marcelo Assunção - 2021',
              ),
            ),
          )
        ],
      ),
    );
  }
}
