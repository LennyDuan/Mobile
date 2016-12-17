package uk.ac.aber.lenny.tempwidget;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.RemoteViews;
import android.widget.Toast;




/**
 * Created by Lenny on 4/28/16.
 */
public class WidgetActionReceiver extends BroadcastReceiver{

    private Context context;
    private static String LogTag = "Widget_Receive_Action_Info: ";

    public static SharedPreferences sharedPreferences;
    public static String UrlOne = "http://users.aber.ac.uk/aos/CSM22/temp1data.php";
    public static String UrlTwo = "http://users.aber.ac.uk/aos/CSM22/temp2data.php";
    public static String UrlDownLoad = UrlOne;
    public static String prefData = "mypref";
    private  static  String cTimeString = "..:..", cTempString = ".....", aTempString = " .....",
            minTempString = ".....", maxTempString = ".....", URL = "Loading..";


    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i(LogTag, "Receive Intent Done");
        this.context = context;

        //Receive Action and Choose right function

        if(intent.getAction().equals(WidgetProvider.WIDGET_REFRESH_ACTION)) {
            updateWidgetLitsener(context);
        }

        if(intent.getAction().equals(WidgetProvider.WIDGET_CHANGE_URL_ACTION)) {
            changeUrlFromSharePreference();
            updateWidgetLitsener(context);
        }

    }

    //Save Data in shareReference
    private void saveURL(Context context, String storeURL) {
        WidgetActionReceiver.sharedPreferences = context.getSharedPreferences(WidgetActionReceiver.prefData, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = WidgetActionReceiver.sharedPreferences.edit();
        editor.putString("url", storeURL);
        editor.commit();
    }

    //Change URL from Sharepreference
    private void changeUrlFromSharePreference() {
        Log.i(LogTag, "Change URL work");
        if (UrlDownLoad.equals(UrlOne)) {
            saveURL(context, UrlTwo);
            UrlDownLoad = sharedPreferences.getString("url", "No this url");
        } else if (UrlDownLoad.equals(UrlTwo)) {
            saveURL(context, UrlOne);
            UrlDownLoad = sharedPreferences.getString("url", "No this url");
        } else {
            UrlDownLoad = UrlOne;
        }
        Toast.makeText(context,"Url has changed to: " + UrlDownLoad, Toast.LENGTH_SHORT).show();
    }


    private void updateWidgetLitsener(Context context) {
        //For First open the App
        saveURL(context, UrlDownLoad);
        UrlDownLoad = sharedPreferences.getString("url", UrlOne);
        //Initial Widget First

        initialWidget(context);

        //Update View From URL
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.activity_widget_provider);
        AsyncDownloader downloader = new AsyncDownloader(context);
        downloader.execute(context);
        Log.i(LogTag, "AsyncDownLoad URL Finish");


        //Re-regiester Button
        remoteViews.setOnClickPendingIntent(R.id.refreshBtn, WidgetProvider.refreshPendingIntent(context));
        remoteViews.setOnClickPendingIntent(R.id.urlBtn, WidgetProvider.urlPendingIntent(context));
        WidgetProvider.widgetUpdate(context.getApplicationContext(), remoteViews);


    }


    //Initial / Set static Widget
    public static void initialWidget(Context context) {

        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.activity_widget_provider);

        remoteViews.setTextViewText(R.id.cTime, cTimeString );
        remoteViews.setTextViewText(R.id.cTemp, cTempString);
        remoteViews.setTextViewText(R.id.aTemp, aTempString);
        remoteViews.setTextViewText(R.id.minTemp, minTempString);
        remoteViews.setTextViewText(R.id.maxTemp, maxTempString);
        remoteViews.setTextViewText(R.id.url, URL);

        WidgetProvider.widgetUpdate(context.getApplicationContext(), remoteViews);

    }

    //Use data from URL to updateView
    public void updateView(Context context) {
        AsyncDownloader downloader = new AsyncDownloader(context);
        downloader.execute(context);
        Log.i(LogTag, "AsyncDownLoad URL Finish");
    }


}
