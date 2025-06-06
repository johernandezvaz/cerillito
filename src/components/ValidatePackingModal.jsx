import React from 'react';
import { XMarkIcon, CheckCircleIcon, ExclamationCircleIcon } from '@heroicons/react/24/outline';

function ValidatePackingModal({ validationResult, onClose }) {
  const { isValid, message, details } = validationResult;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div className="flex justify-between items-center p-4 border-b">
          <h2 className="text-xl font-semibold text-gray-800">Resultado de Validación</h2>
          <button 
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700"
          >
            <XMarkIcon className="h-6 w-6" />
          </button>
        </div>
        
        <div className="p-4">
          <div className="flex items-center mb-4">
            {isValid ? (
              <CheckCircleIcon className="h-12 w-12 text-green-500 mr-4" />
            ) : (
              <ExclamationCircleIcon className="h-12 w-12 text-red-500 mr-4" />
            )}
            <div>
              <h3 className={`text-lg font-semibold ${isValid ? 'text-green-700' : 'text-red-700'}`}>
                {message}
              </h3>
            </div>
          </div>
          
          {details && details.length > 0 && (
            <div className="mt-4 border-t pt-4">
              <h4 className="font-semibold mb-2">Detalles:</h4>
              <ul className="list-disc pl-5 space-y-1">
                {details.map((detail, index) => (
                  <li key={index} className="text-gray-700">{detail}</li>
                ))}
              </ul>
            </div>
          )}
          
          <div className="mt-6 flex justify-end">
            <button
              onClick={onClose}
              className={`px-4 py-2 rounded text-white ${
                isValid ? 'bg-green-600 hover:bg-green-700' : 'bg-blue-600 hover:bg-blue-700'
              }`}
            >
              {isValid ? 'Aceptar' : 'Entendido'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default ValidatePackingModal;