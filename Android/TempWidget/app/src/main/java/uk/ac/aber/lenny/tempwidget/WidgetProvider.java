package uk.ac.aber.lenny.tempwidget;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import android.util.Log;
import android.widget.RemoteViews;


public class WidgetProvider extends AppWidgetProvider{


    final static String WIDGET_REFRESH_ACTION = "lenny.temp.REFRESH_WIDGET";
    final static String WIDGET_CHANGE_URL_ACTION = "lenny.temp.CHANGE_URL";
    final private static String LogTag = "Widget_Log_Info: ";



    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);

        Log.i(LogTag, "Data has been saved and Widget Run Well");
        //Initializing Widget Layout
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.activity_widget_provider);

        //Register button and set initial widget view
        remoteViews.setOnClickPendingIntent(R.id.refreshBtn, refreshPendingIntent(context));
        remoteViews.setOnClickPendingIntent(R.id.urlBtn, urlPendingIntent(context));
        Log.i(LogTag, "Widget Btn and Text Setting Done");

        WidgetActionReceiver widgetActionReceiver = new WidgetActionReceiver();
        widgetActionReceiver.updateView(context);

        widgetUpdate(context, remoteViews);
    }

    //Update Widget
    public static void widgetUpdate(Context context, RemoteViews remoteViews) {

        Log.i(LogTag, "Update Widget Action");

        ComponentName myWidget = new ComponentName(context, WidgetProvider.class);
        AppWidgetManager manager = AppWidgetManager.getInstance(context);
        manager.updateAppWidget(myWidget, remoteViews);
    }

    //PendingIntent for refresh button
    public static PendingIntent refreshPendingIntent(Context context) {
        Log.i(LogTag, "Refresh Btn Action");

        Intent intent = new Intent();
        intent.setAction(WIDGET_REFRESH_ACTION);
        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    //PendingIntent for url button
    public static  PendingIntent urlPendingIntent(Context context) {
        Log.i(LogTag, "URL Btn Action");

        Intent intent = new Intent();
        intent.setAction(WIDGET_CHANGE_URL_ACTION);
        return  PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

}
