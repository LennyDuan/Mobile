package uk.ac.aber.lenny.tempwidget;

/**
 * Created by Lenny on 4/28/16.
 */
public class TimeTemp {
    private String hour;
    private String min;
    private String temp;

    public TimeTemp(String hour, String min, String temp) {
        this.hour = hour;
        this.min = min;
        this.temp = temp;
    }

    public String getHour() {
        return hour;
    }

    public void setHour(String hour) {
        this.hour = hour;
    }

    public String getMin() {
        return min;
    }

    public void setMin(String min) {
        this.min = min;
    }

    public String getTemp() {
        return temp;
    }

    public void setTemp(String temp) {
        this.temp = temp;
    }
}
