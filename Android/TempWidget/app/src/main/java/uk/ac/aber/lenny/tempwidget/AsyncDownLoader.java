package uk.ac.aber.lenny.tempwidget;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.RemoteViews;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;



import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

/**
 * Created by Lenny on 4/28/16.
 */
class AsyncDownloader extends AsyncTask<Object, String, Integer> {
    private static ArrayList<TimeTemp> tempList = new ArrayList<TimeTemp>();
    private static String LogTag = "Widget_AsyncDownloader_Action_Info: ";

    private  String cTimeString = "loading..", cTempString = "loading..", aTempString = " .....",
            minTempString = ".....", maxTempString = ".....";

    private Context context;
    public AsyncDownloader(Context context) {
        this.context = context;
        Log.i(LogTag, "AsyncDownLoad URL data start");

    }

    @Override
    protected Integer doInBackground(Object... params) {
        //Download data from Url and save in ArrayList
        try {
            getDataFromArray();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Setting data context to Widget
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.activity_widget_provider);
        remoteViews.setTextViewText(R.id.cTime, cTimeString );
        remoteViews.setTextViewText(R.id.cTemp, cTempString);
        remoteViews.setTextViewText(R.id.aTemp, aTempString);
        remoteViews.setTextViewText(R.id.minTemp, minTempString);
        remoteViews.setTextViewText(R.id.maxTemp, maxTempString);
        remoteViews.setTextViewText(R.id.url, WidgetActionReceiver.UrlDownLoad);
        WidgetProvider.widgetUpdate(context.getApplicationContext(), remoteViews);

        return null;
    }

    private void getDataFromArray() throws IOException {
        //Empty TempList
        tempList.clear();

        //Get Data from Url and save in Array
        getDataFromUrl();

        //Set current temp;
        TimeTemp ctimeTemp;
        ctimeTemp = tempList.get(tempList.size() - 1);
        cTempString = ctimeTemp.getTemp();

        //Set Average Temp String
        String currentHour = tempList.get(tempList.size() - 1).getHour();
        String lastHour = String.valueOf(Integer.parseInt(currentHour) - 1);
        float allTemp = 0;
        int allTime = 0;
        for (TimeTemp timeTemp: tempList) {
            if (timeTemp.getHour().equals(lastHour)) {
                allTemp += Float.parseFloat(timeTemp.getTemp());
                allTime ++;
            }
        }
        float aTemp = allTemp / allTime;
        String averageTemp = String.format("%.2f", aTemp);
        Log.i(LogTag, "Average Temps of last hour: " + averageTemp);
        aTempString = averageTemp;

        //Sort List and get Min Max temp of a day
        //Set Min and Max Temp
        Collections.sort(tempList, new Comparator<TimeTemp>() {
            @Override
            public int compare(TimeTemp timeTemp, TimeTemp timeTemp2) {
                return timeTemp.getTemp().compareTo(timeTemp2.getTemp());
            }
        });
        minTempString = tempList.get(0).getTemp();
        maxTempString = tempList.get(tempList.size() - 1).getTemp();
        Log.i(LogTag, "Min Temp: " + minTempString);
        Log.i(LogTag, "Max Temp: " + maxTempString);
    }

    private void getDataFromUrl() throws IOException {
        //Get Data from Url and save to ArrayList
        //Set Url
        URL xmlUrl = new URL(WidgetActionReceiver.UrlDownLoad);
        InputStream in = xmlUrl.openStream();
        Document doc = parse(in);
        doc.getDocumentElement().normalize();

        // Get and Set Current Time
        NodeList tempsList = doc.getElementsByTagName("temps");
        String servername = (String) ((Element) tempsList.item(0)).getElementsByTagName("currentTime").
                item(0).getChildNodes().item(0).getNodeValue();
        cTimeString = servername;

        // Get All time and temps and save them in array list.
        NodeList timeList = doc.getElementsByTagName("reading");
        Log.i(LogTag, "----------------------------");
        for (int temp = 0; temp < timeList.getLength(); temp++) {
            Node nNode = timeList.item(temp);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) nNode;
                TimeTemp timeTemp = new TimeTemp(eElement.getAttribute("hour"),
                        eElement.getAttribute("min"), eElement.getAttribute("temp"));
                tempList.add(timeTemp);
            }
        }
    }

    private Document parse (InputStream is) {
        Document ret = null;
        DocumentBuilderFactory domFactory;
        DocumentBuilder builder;
        try {
            domFactory = DocumentBuilderFactory.newInstance();
            domFactory.setValidating(false);
            domFactory.setNamespaceAware(false);
            builder = domFactory.newDocumentBuilder();
            ret = builder.parse(is);
        }
        catch (Exception ex) {
            Log.i(LogTag, "unable to load XML: " + ex);
        }
        return ret;
    }


}