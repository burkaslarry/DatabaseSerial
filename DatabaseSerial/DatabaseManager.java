package com.cei.test.backend;

import java.sql.SQLException;
import java.util.*;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;

import com.cei.test.model.Checkpoint;
import com.cei.test.model.Commandsent;
import com.cei.test.model.Dronepoint;
import com.cei.test.model.FlightProfile;
import com.cei.test.model.Journey;
import com.cei.test.model.testDevice;
import com.cei.test.model.Taskpoint;
import com.cei.test.model.Trajectory;
import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;r
import com.j256.ormlite.stmt.UpdateBuilder; 

public class DatabaseManager
{
	static private volatile DatabaseManager instance;

	static public DatabaseManager getInstance()
	{
		return instance;
	}
	 
	static public void init(Context ctx)
	{
		if (null == instance)
		{
			instance = new DatabaseManager(ctx);
		}
	}

	private DatabaseHelper helper;

	private DatabaseManager(Context ctx)
	{
		helper = new DatabaseHelper(ctx);
	}


	private DatabaseHelper getHelper()
	{
		return helper;
	}

	public void addDevice(TestDevice nd){
		try
		{ 
			getHelper().getDeviceDao().create(nd);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	public void updateDevice(TestDevice nd , String uuid ){
		try
		{
			if(getDevice(uuid)!=null){ //if not null update

				UpdateBuilder<TestDevice, Integer> updateBuilder = getHelper().getDeviceDao().updateBuilder();				
				updateBuilder.where().eq("uuid", uuid) ;
				updateBuilder.updateColumnValue("dname", nd.getName());
				updateBuilder.updateColumnValue("uuid", nd.getUUid()); 
				//updateBuilder.updateColumnValue(columnName, value)
				updateBuilder.update(); 					
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public List<TestDevice> getAllTestDevice()
	{
		List<TestDevice> records = new ArrayList<TestDevice>();

		try
		{
			QueryBuilder<TestDevice, Integer> queryBuilder = getHelper().getDeviceDao().queryBuilder(); 
			PreparedQuery<TestDevice> preparedQuery = queryBuilder.prepare();
			records = getHelper().getDeviceDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
		
	public TestDevice getDevice(String uuid) {
		// TODO Auto-generated method stub
		TestDevice records = null;
		if(uuid==null ) 
			return null ;
			
		if(uuid.trim().length() == 0)
			return null ;
		
		try
		{
			QueryBuilder<TestDevice, Integer> queryBuilder = getHelper().getDeviceDao().queryBuilder();		
			queryBuilder.where().eq("uuid",  uuid);
			PreparedQuery<TestDevice> preparedQuery = queryBuilder.prepare();
			records =getHelper().getDeviceDao().queryForFirst(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}

	public void addFlightProfile(int index , FlightProfile s)
	{
		try
		{
			s.setId(index);
			getHelper().getflightDao().create(s);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public void clearFlightProfile(FlightProfile f){
		try
		{
			getHelper().getflightDao().delete(f);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
 	
	public List<FlightProfile> getAllFlightProfile()
	{
		List<FlightProfile> records = new ArrayList<FlightProfile>();

		try
		{
			QueryBuilder<FlightProfile, Integer> queryBuilder = getHelper().getflightDao().queryBuilder(); 
			PreparedQuery<FlightProfile> preparedQuery = queryBuilder.prepare();
			records = getHelper().getflightDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}

	public List<FlightProfile> getPagingFlightProfile(long limit , int page)
	{
		List<FlightProfile> records = new ArrayList<FlightProfile>();

		try
		{
			QueryBuilder<FlightProfile, Integer> queryBuilder = 
					getHelper().getflightDao().queryBuilder().limit(limit).offset(page*limit);

			PreparedQuery<FlightProfile> preparedQuery = queryBuilder.prepare();
			records = getHelper().getflightDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}

	public FlightProfile getFlightProfile(int i) {
		// TODO Auto-generated method stub
		FlightProfile records = null;

		try
		{
			QueryBuilder<FlightProfile, Integer> queryBuilder = getHelper().getflightDao().queryBuilder();		
			queryBuilder.where().eq("id", i);
			PreparedQuery<FlightProfile> preparedQuery = queryBuilder.prepare();
			records =getHelper().getflightDao().queryForFirst(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public FlightProfile getFlightProfileByName(String name) {
		// TODO Auto-generated method stub
		FlightProfile records = null;
		if(name==null ) 
			return records ;
			
		if(name.trim().length() == 0)
			return records ;
		
		try
		{
			QueryBuilder<FlightProfile, Integer> queryBuilder = getHelper().getflightDao().queryBuilder();		
			queryBuilder.where().eq("name", name);

			PreparedQuery<FlightProfile> preparedQuery = queryBuilder.prepare();
			records =getHelper().getflightDao().queryForFirst(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}

	public boolean searchNameFound(String name) {
		// TODO Auto-generated method stub
		boolean isFound = false;
		List<String> nameList =   new ArrayList<String > ();	
		List<FlightProfile> records =  getAllFlightProfile();
		for(FlightProfile fpo  :  records ){
			nameList.add(fpo.getName());
		}
		for (String fpoName : nameList ){
			if(name.equals(fpoName)){
				isFound = true;
				break;
			}
		}	
		return isFound;
	}

	public void createOrUpdateProfile(int i , FlightProfile fp , String createString, String editString , Activity actv){

		try
		{
			//FlightProfile fp =  getFlightProfile (i);
			if(getFlightProfile(i)!=null){ //if not null update

				UpdateBuilder<FlightProfile, Integer> updateBuilder = getHelper().getflightDao().updateBuilder();				
				updateBuilder.where().eq("id", i) ;
				updateBuilder.updateColumnValue("name", fp.getName());
				updateBuilder.updateColumnValue("fmode", fp.getFlightmode());
				updateBuilder.updateColumnValue("maxangle", fp.getMaxAngle());
				updateBuilder.updateColumnValue("maxrotate", fp.getMaxRotate());
				updateBuilder.updateColumnValue("maxclimb", fp.getMaxClimb());
				updateBuilder.updateColumnValue("middeadband", fp.getMidDeadBand());
				updateBuilder.updateColumnValue("slowdacc", fp.getSlowDownAcc());
				//updateBuilder.updateColumnValue(columnName, value)
				updateBuilder.update();
				Toast.makeText(actv,  editString, Toast.LENGTH_LONG).show();							

				//getHelper().getflightDao().update(updateBuilder.prepare());
			}else{ //else create new record 
				addFlightProfile( i , fp);
				Toast.makeText(actv,  createString, Toast.LENGTH_LONG).show();							

			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	//Journey	
	public List<Journey> getAllJour()
	{
		List<Journey> records = new ArrayList<Journey>();

		try
		{
			QueryBuilder<Journey, Integer> queryBuilder = getHelper().getJDao().queryBuilder(); 
			PreparedQuery<Journey> preparedQuery = queryBuilder.prepare();
			records = getHelper().getJDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public Journey getJ(int i , boolean latest) {
		// TODO Auto-generated method stub
		Journey records = null;

		try
		{
			if(latest==true){

				QueryBuilder<Journey, Integer> queryBuilder = getHelper().getJDao().queryBuilder();		
				queryBuilder.orderBy("id", false);
				PreparedQuery<Journey> preparedQuery = queryBuilder.prepare();
				records =getHelper().getJDao().queryForFirst(preparedQuery);
			}else{

				QueryBuilder<Journey, Integer> queryBuilder = getHelper().getJDao().queryBuilder();		
				queryBuilder.where().eq("id", i);
				PreparedQuery<Journey> preparedQuery = queryBuilder.prepare();
				records =getHelper().getJDao().queryForFirst(preparedQuery);	
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	

	public void deleteJ (  int i ) {
		try
		{
			Journey j =  getJ(i , false) ;
			
			//FlightProfile fp =  getFlightProfile (i);
			if(j!=null){ //if not null update
				
				getHelper() .getJDao().delete(j) ; 
				//getHelper().getflightDao().update(updateBuilder.prepare());
			} 
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	
		
	public void createOrUpdateJ (String desp , int i ) {
		try
		{
			//FlightProfile fp =  getFlightProfile (i);
			if(getJ(i , false)!=null){ //if not null update

				UpdateBuilder<Journey, Integer> updateBuilder = getHelper().getJDao().updateBuilder();				
				updateBuilder.where().eq("id", i) ;
				updateBuilder.updateColumnValue("desp", desp); 
 				updateBuilder.update();
 
				//getHelper().getflightDao().update(updateBuilder.prepare());
			}else{ //else create new record 
				addJ( desp, i );
 
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	 
	public  void addJ(String desp, int i) {
		// TODO Auto-generated method stub
		try
		{ 
			Journey j =  new Journey(desp);
			getHelper().getJDao().create(j);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	

	//Trajectory	
	public List<Trajectory> getAllTrajectory()
	{
		List<Trajectory> records = new ArrayList<Trajectory>();

		try
		{
			QueryBuilder<Trajectory, Integer> queryBuilder = getHelper().getTrDao().queryBuilder(); 
			PreparedQuery<Trajectory> preparedQuery = queryBuilder.prepare();
			records = getHelper().getTrDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public Trajectory getTr(int i , boolean latest) {
		// TODO Auto-generated method stub
		Trajectory records = null;

		try
		{
			if(latest == true) {

				QueryBuilder<Trajectory, Integer> queryBuilder = getHelper().getTrDao().queryBuilder();
				queryBuilder.orderBy("id", false);	
				PreparedQuery<Trajectory> preparedQuery = queryBuilder.prepare();				
				records = getHelper().getTrDao().query(preparedQuery).get(0);
				
			}else{

				QueryBuilder<Trajectory, Integer> queryBuilder = getHelper().getTrDao().queryBuilder();		
				queryBuilder.where().eq("id", i);
				PreparedQuery<Trajectory> preparedQuery = queryBuilder.prepare();
				records =getHelper().getTrDao().queryForFirst(preparedQuery);
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
		
	public void createOrUpdateTr (String desp , int i ) {
		try
		{
			//FlightProfile fp =  getFlightProfile (i);
			if(getJ(i , false)!=null){ //if not null update

				UpdateBuilder<Journey, Integer> updateBuilder = getHelper().getJDao().updateBuilder();				
				updateBuilder.where().eq("id", i) ;
				updateBuilder.updateColumnValue("desp", desp); 
 				updateBuilder.update();
 
				//getHelper().getflightDao().update(updateBuilder.prepare());
			}else{ //else create new record 
				addTr( desp, i );
 
			}
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	 
	public  void addTr(String desp, int i) {
		// TODO Auto-generated method stub
		try
		{ 
			Trajectory j =  new Trajectory(desp);
			getHelper().getTrDao().create(j);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	public  void addDrone(Dronepoint dp ) {
		// TODO Auto-generated method stub
		try
		{ 
		 
			getHelper().getDrDao().create(dp);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	
	
	//Command
	public Commandsent getCmd(int i) {
		// TODO Auto-generated method stub
		Commandsent records = null;

		try
		{
			QueryBuilder<Commandsent, Integer> queryBuilder = getHelper().getComDao().queryBuilder();		
			queryBuilder.where().eq("id", i);
			PreparedQuery<Commandsent> preparedQuery = queryBuilder.prepare();
			records =getHelper().getComDao().queryForFirst(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public  void addCmd(String desp, int i) {
		// TODO Auto-generated method stub
		try
		{ 
			Commandsent j =  new Commandsent(i ,desp);
			getHelper().getComDao().createOrUpdate(j);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public void deleteCmd(Commandsent f){
		try
		{
			getHelper().getComDao().delete(f);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	public void deleteCmdAll(){
	 	List<Commandsent> records = new ArrayList<Commandsent>();

		try
		{
			QueryBuilder<Commandsent, Integer> queryBuilder = 
					getHelper().getComDao().queryBuilder();
			PreparedQuery<Commandsent> preparedQuery = queryBuilder.prepare();
			records = getHelper().getComDao().query(preparedQuery);
			for(Commandsent cf : records) {
				deleteCmd(cf);
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	
	//Taskpoint
	public List<Taskpoint> getTkByMid(int mid) {
		// TODO Auto-generated method stub
		List<Taskpoint> records = new ArrayList<Taskpoint>();
		try
		{
			QueryBuilder<Taskpoint, Integer> queryBuilder = 
					getHelper().getTkDao().queryBuilder();
			queryBuilder.where().eq("mid", mid);
			PreparedQuery<Taskpoint> preparedQuery = queryBuilder.prepare();
			records = getHelper().getTkDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public List<Taskpoint> getTkGroupExecute(int status , boolean ifEarliest , int mid) {
		// TODO Auto-generated method stub
		List<Taskpoint> records = new ArrayList<Taskpoint>();
		try
		{
			QueryBuilder<Taskpoint, Integer> queryBuilder = 
					getHelper().getTkDao().queryBuilder();
			if(ifEarliest==true){
				queryBuilder.where().eq("mid", mid).and().eq("status", status);
				queryBuilder.orderBy("id", true);	
			}else{
				queryBuilder.where().eq("mid", mid);
			}

			PreparedQuery<Taskpoint> preparedQuery = queryBuilder.prepare();
 			records = getHelper().getTkDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public Taskpoint getTkp(int tkpid , int mid) {
		// TODO Auto-generated method stub
		Taskpoint records = new Taskpoint();
		try
		{
			QueryBuilder<Taskpoint, Integer> queryBuilder = getHelper().getTkDao().queryBuilder();			
			queryBuilder.where().eq("mid", mid).and().eq("id", tkpid);
			PreparedQuery<Taskpoint> preparedQuery = queryBuilder.prepare();
 			records =getHelper().getTkDao().queryForFirst(preparedQuery); 			
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	public List<Taskpoint> getTkGroupPaused(int status , int mid) {
		// TODO Auto-generated method stub
		List<Taskpoint> records = null;
		try
		{
			QueryBuilder<Taskpoint, Integer> queryBuilder = 
		 	getHelper().getTkDao().queryBuilder();
			queryBuilder.where().eq("mid", mid).and().eq("status", status);
			queryBuilder.orderBy("id", true);	

			PreparedQuery<Taskpoint> preparedQuery = queryBuilder.prepare();
 			records = getHelper().getTkDao().query(preparedQuery);
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return records;
	}
	
	
	public void deleteTaskpoint(int tkpid  , int jid){
		try
		{
			Taskpoint tkp = getTkp(tkpid, jid);			
			if(tkp!=null) {
				getHelper().getTkDao().delete(tkp);	
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	
	public void deleteTaskpoint(Taskpoint f){
		try
		{
			getHelper().getTkDao().delete(f);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public void updateTkpStatus (int mid,  int tkpid , int statusId) {
		try
		{
			if(getTkp(tkpid, mid)!=null){ //if not null update
				
				UpdateBuilder<Taskpoint, Integer> updateBuilder = getHelper().getTkDao().updateBuilder();				
				updateBuilder.where().eq("mid", mid).and().eq("id", tkpid);				
				updateBuilder.updateColumnValue("status", statusId);
				updateBuilder.update(); 					
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	public  void addTaskpoint(Taskpoint tk) {
		// TODO Auto-generated method stub
		try
		{ 
			System.out.println("go create tkp");
			getHelper().getTkDao().create(tk);
		}
		catch (Exception ex)
		{
			System.out.println("error");
			ex.printStackTrace();
		}
	}

	public  void addTaskpoint(Checkpoint sk , int masterJourneyId) {
		// TODO Auto-generated method stub
		try
		{ 
			Taskpoint tk = new Taskpoint ();
			tk.setStatus(0);					
			tk.setAltitude(sk.getAltitude());
			tk.setFacing(sk.getFacing());
			tk.setHoldtime(sk.getHoldTime());
			tk.setLatitude((float) sk.getPoint().latitude);
			tk.setLongitude((float) sk.getPoint().longitude);
			tk.setMid(masterJourneyId);
			tk.setRotation(sk.getRotation());
			tk.setSpeed(sk.getSpeed());
			tk.setId(sk.getId());
			addTaskpoint(tk);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	
}
