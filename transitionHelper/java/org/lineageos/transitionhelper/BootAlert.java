package org.lineageos.transitionhelper;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class BootAlert extends BroadcastReceiver {

    @Override
    public void onReceive(Context mContext, Intent mIntent) {
        if ("android.intent.action.BOOT_COMPLETED".equals(mIntent.getAction())) {
            Log.d("OHAI", "BOOTED");
            mContext.startActivity(new Intent(mContext, MainActivity.class));
        }
    }

}
