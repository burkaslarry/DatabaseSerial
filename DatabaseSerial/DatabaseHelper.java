package com.cei.novax.backend;



import android.content.Context;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;

import com.cei.novax.model.Commandsent;
import com.cei.novax.model.Dronepoint;
import com.cei.novax.model.FlightProfile;
import com.cei.novax.model.Journey;
import com.cei.novax.model.NovaxDevice;
import com.cei.novax.model.Taskpoint;
import com.cei.novax.model.Trajectory;
import com.j256.ormlite.android.apptools.OrmLiteSqliteOpenHelper;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;

public class DatabaseHelper extends OrmLiteSqliteOpenHelper {


	private static final String DATABASE_NAME = "novax.sqlite";
	private static final int DATABASE_VERSION = 1;

	private Dao<FlightProfile, Integer> flightDao = null;
	private Dao<NovaxDevice, Integer> deviceDao = null;
	private Dao<Taskpoint, Integer> tkDao = null;
	private Dao<Journey, Integer> jDao = null;
	private Dao<Trajectory, Integer> tjDao = null;
	private Dao<Dronepoint, Integer> drDao = null;
	private Dao<Commandsent, Integer> cDao = null; 
	
	public DatabaseHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase database, ConnectionSource connectionSource) {
		// TODO Auto-generated method stub
		try {
			TableUtils.createTable(connectionSource, FlightProfile.class);
			TableUtils.createTable(connectionSource, NovaxDevice.class);
			TableUtils.createTable(connectionSource, Taskpoint.class);
			TableUtils.createTable(connectionSource, Journey.class);
			TableUtils.createTable(connectionSource, Trajectory.class);
			TableUtils.createTable(connectionSource, Dronepoint.class);
			TableUtils.createTable(connectionSource, Commandsent.class);

		} catch (java.sql.SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
 

	@Override
	public void onUpgrade(SQLiteDatabase db, ConnectionSource connectionSource, 
			int oldVersion, int newVersion) {
		// TODO Auto-generated method stub
		try {
			//TableUtils.dropTable(connectionSource, FlightProfile.class, true);	
			//TableUtils.dropTable(connectionSource, NovaxDevice.class , true);
			//TableUtils.dropTable(connectionSource, Taskpoint.class , true);
			//TableUtils.dropTable(connectionSource, Journey.class , true);
			//TableUtils.dropTable(connectionSource, Trajectory.class , true);
			//TableUtils.dropTable(connectionSource, Dronepoint.class , true);
			TableUtils.dropTable(connectionSource, Commandsent.class , true);

			
			onCreate( db, connectionSource);
		} catch (java.sql.SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static DatabaseHelper instance;  

	public static synchronized DatabaseHelper getHelper(Context context)  
	{  
		if (instance == null)  
		{  
			synchronized (DatabaseHelper.class)  
			{  
				if (instance == null)  
					instance = new DatabaseHelper(context);  
			}  
		}  
		return instance;  
	}  
  
	 public Dao<Taskpoint, Integer> getTkDao() throws SQLException  
	 {  
		 if (tkDao == null)  
		 {  
			 try {
				 tkDao = getDao(Taskpoint.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return tkDao;  
	 }  

	 
	 public Dao<FlightProfile, Integer> getflightDao() throws SQLException  
	 {  
		 if (flightDao == null)  
		 {  
			 try {
				flightDao = getDao(FlightProfile.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return flightDao;  
	 }  
	 
	 public Dao<NovaxDevice, Integer> getDeviceDao() throws SQLException  
	 {  
		 if (deviceDao == null)  
		 {  
			 try {
				 deviceDao = getDao(NovaxDevice.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return deviceDao;  
	 }  
	 
	 public Dao<Journey, Integer> getJDao() throws SQLException  
	 {  
		 if (jDao == null)  
		 {  
			 try {
				 jDao = getDao(Journey.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return jDao;  
	 }  
	 
	 public Dao<Trajectory, Integer> getTrDao() throws SQLException  
	 {  
		 if (tjDao == null)  
		 {  
			 try {
				 tjDao = getDao(Trajectory.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return tjDao;  
	 }  
	 
	 public Dao<Dronepoint, Integer> getDrDao() throws SQLException  
	 {  
		 if (drDao == null)  
		 {  
			 try {
				 drDao = getDao(Dronepoint.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return drDao;  
	 }  
	 
	 public Dao<Commandsent, Integer> getComDao() throws SQLException  
	 {  
		 if (cDao == null)  
		 {  
			 try {
				 cDao = getDao(Commandsent.class);
			} catch (java.sql.SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  
		 }  
		 return cDao;  
	 }  
	 

	 @Override  
	 public void close()  
	 {  
		 super.close();  
		 flightDao = null;  
		 deviceDao = null;
		 tkDao = null;
		 jDao = null;
		 tjDao = null;
		 drDao = null;
		 cDao = null; 
	 }  

}  

