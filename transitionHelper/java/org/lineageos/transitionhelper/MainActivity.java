package org.lineageos.transitionhelper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new AlertDialog.Builder(this)
                .setTitle(R.string.title)
                .setMessage(R.string.message)
                .setPositiveButton(R.string.gotit, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        finish();
                    }
                })
                .setCancelable(false)
                .show();
    }

}
