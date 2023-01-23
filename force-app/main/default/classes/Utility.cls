/**
 * Utility Description
 * It contains all the literals and other statis variables with some value which can be reused as many times as needed.
 * @author developer
 */
public class Utility{
    public static final String SELLSIDE = 'Sell';
    public static final String BUYSIDE = 'Buy';
    public static final String LIMITTYPE = 'Limit';
    public static final String BUYTYPE = 'Market';
    public static final String CANCELSTATUS = 'Cancelled';
    public static final String FILLEDSTATUS = 'Filled';
    public static final String OPENSTATUS = 'Open';
    public static final String FOKLIMIT = 'FoK (Fill or Kill)';
    public static final String DAYLIMIT = 'Day';
    public static Boolean firstRun = true;
    
    public static Boolean triggerFirstRun(){
        if(firstRun){
            firstRun=false;
            return true;
        }else{
            return false;
        }
    }
}